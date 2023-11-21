#!/usr/bin/perl

use strict;
use warnings;
use Crypt::Cipher;
use Crypt::PBKDF2;
use Crypt::Random qw/makerandom_octet/;
use MIME::Base64;
use Storable;
use Bio::Seq;
use Bio::Tools::Run::Alignment::Clustalw;
use Bio::Tools::Motif;
use Bio::Tools::IUPAC;
use Bio::SeqUtils;

package BioCrypto {
    sub new {
        my ($class, $password, $cipher_name) = @_;
        my $self = {
            password    => $password,
            cipher_name => $cipher_name,
        };
        bless($self, $class);
        return $self;
    }

    sub generate_key {
        my ($self, $salt, $key_length) = @_;
        my $pbkdf2 = Crypt::PBKDF2->new(
            hash_class => 'HMACSHA2',
            iterations => 10000,
            output_len => $key_length,
            salt_len   => length($salt),
        );
        return $pbkdf2->PBKDF2($salt, $self->{password});
    }

    sub encrypt {
        my ($self, $plaintext) = @_;
        my $salt = makerandom_octet(Length => 16);
        my $key_length = 32; # 256 bits
        my $key = $self->generate_key($salt, $key_length);
        my $cipher = Crypt::Cipher->new($self->{cipher_name}, $key);
        my $iv = makerandom_octet(Length => $cipher->blocksize);
        my $ciphertext = $cipher->encrypt($plaintext, $iv);
        return {
            salt       => $salt,
            ciphertext => $ciphertext,
            iv         => $iv,
        };
    }

    sub decrypt {
        my ($self, $ciphertext, $salt, $iv) = @_;
        my $key_length = 32; # 256 bits
        my $key = $self->generate_key($salt, $key_length);
        my $cipher = Crypt::Cipher->new($self->{cipher_name}, $key);
        my $plaintext = $cipher->decrypt($ciphertext, $iv);
        return $plaintext;
    }

    sub align_sequences {
        my ($self, $seq1, $seq2) = @_;
        my $factory = Bio::Tools::Run::Alignment::Clustalw->new();
        my $alignment = $factory->align([$seq1, $seq2]);
        return $alignment;
    }

    sub find_motif {
        my ($self, $seq, $motif_pattern) = @_;
        my $motif_tool = Bio::Tools::Motif->new(-pattern => $motif_pattern);
        my $result = $motif_tool->scan_seq($seq);
        return $result;
    }

    sub translate_sequence {
        my ($self, $dna_sequence) = @_;
        my $seq_obj = Bio::Seq->new(-seq => $dna_sequence);
        my $protein_sequence = $seq_obj->translate()->seq();
        return $protein_sequence;
    }

    sub reverse_complement {
        my ($self, $dna_sequence) = @_;
        my $seq_obj = Bio::Seq->new(-seq => $dna_sequence);
        my $reverse_complement = $seq_obj->revcom()->seq();
        return $reverse_complement;
    }

    sub analyze_protein_sequence {
        my ($self, $protein_sequence) = @_;
        my $iupac_tool = Bio::Tools::IUPAC->new(-seq => $protein_sequence);
        my $aa_count = $iupac_tool->aa_count();
        my $molecular_weight = $iupac_tool->molecular_weight();
        my $isoelectric_point = $iupac_tool->isoelectric_point();
        return {
            aa_count           => $aa_count,
            molecular_weight   => $molecular_weight,
            isoelectric_point => $isoelectric_point,
        };
    }
}

package IoTControl {
    sub new {
        my ($class) = @_;
        my $self = {};
        bless($self, $class);
        return $self;
    }

    sub collect_data {
        my ($self) = @_;
        my %data = (
            temperature => rand(30) + 20,
            humidity    => rand(50) + 30,
            pressure    => rand(1000) + 900,
        );
        return \%data;
    }

    sub control_device {
        my ($self, $device, $command) = @_;
        return "Sent command '$command' to device '$device'.";
    }
}

my $bio_crypto = BioCrypto->new("MySecurePassword", "AES");
my $iot_control = IoTControl->new();

my $message = "Hello, World!";
my $encrypted_data = $bio_crypto->encrypt($message);
my $decrypted_message = $bio_crypto->decrypt(
    $encrypted_data->{ciphertext},
    $encrypted_data->{salt},
    $encrypted_data->{iv}
);

print "Original Message: $message\n";
print "Decrypted Message: $decrypted_message\n";

my $seq1 = Bio::Seq->new(-seq => "ACGTAGTACGTAGTACGTAGT");
my $seq2 = Bio::Seq->new(-seq => "TACGTACGTACGTACGTACGT");
my $alignment = $bio_crypto->align_sequences($seq1, $seq2);
print $alignment->pretty_print();

my $sequence = Bio::Seq->new(-seq => "ATGCGCATGACGATGCTAGCTAGCATG");
my $motif_pattern = "ATG";
my $motif_result = $bio_crypto->find_motif($sequence, $motif_pattern);
print "Motif found at positions: " . join(", ", $motif_result->all_positions()) . "\n";

my $dna_sequence = "ATGGCTTAGCTGCTAGCTAGCTAGC";
my $protein_sequence = $bio_crypto->translate_sequence($dna_sequence);
print "Translated Protein Sequence: $protein_sequence\n";

my $rc_dna_sequence = $bio_crypto->reverse_complement($dna_sequence);
print "Reverse Complement DNA: $rc_dna_sequence\n";

my $protein_info = $bio_crypto->analyze_protein_sequence($protein_sequence);
print "Amino Acid Count: " . $protein_info->{aa_count} . "\n";
print "Molecular Weight: " . $protein_info->{molecular_weight} . "\n";
print "Isoelectric Point: " . $protein_info->{isoelectric_point} . "\n";

my $iot_data = $iot_control->collect_data();
print "Collected IoT Data:\n";
foreach my $key (keys %$iot_data) {
    print "$key: $iot_data->{$key}\n";
}

my $device = "IoTDevice1";
my $command = "TurnOn";
my $control_result = $iot_control->control_device($device, $command);
print "IoT Control Result: $control_result\n";

