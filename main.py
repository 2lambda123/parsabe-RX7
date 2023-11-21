from Crypto.Cipher import AES
from Crypto.Protocol.KDF import PBKDF2
from Crypto.Random import get_random_bytes
from Bio.Seq import Seq
from Bio.Align.Applications import ClustalwCommandline
from Bio.SeqUtils import motif
from Bio.SeqUtils import IUPAC

class BioCrypto:
    def __init__(self, password, cipher_name):
        self.password = password
        self.cipher_name = cipher_name

    def generate_key(self, salt, key_length):
        key = PBKDF2(self.password, salt, dkLen=key_length)
        return key

    def encrypt(self, plaintext):
        salt = get_random_bytes(16)
        key_length = 32
        key = self.generate_key(salt, key_length)
        cipher = AES.new(key, AES.MODE_CBC)
        ciphertext = cipher.encrypt(plaintext)
        return {
            'salt': salt,
            'ciphertext': ciphertext,
            'iv': cipher.iv,
        }

    def decrypt(self, ciphertext, salt, iv):
        key_length = 32
        key = self.generate_key(salt, key_length)
        cipher = AES.new(key, AES.MODE_CBC, iv=iv)
        plaintext = cipher.decrypt(ciphertext)
        return plaintext

    def align_sequences(self, seq1, seq2):
        clustalw_cline = ClustalwCommandline("clustalw2", infile="-")
        alignment = clustalw_cline(seq1, seq2)
        return alignment

    def find_motif(self, seq, motif_pattern):
        result = motif.scan_seq(seq, motif_pattern)
        return result

    def translate_sequence(self, dna_sequence):
        seq = Seq(dna_sequence)
        protein_sequence = seq.translate()
        return str(protein_sequence)

    def reverse_complement(self, dna_sequence):
        seq = Seq(dna_sequence)
        reverse_complement = seq.reverse_complement()
        return str(reverse_complement)

    def analyze_protein_sequence(self, protein_sequence):
        aa_count = IUPAC.protein_count(protein_sequence)
        molecular_weight = SeqUtils.molecular_weight(protein_sequence)
        isoelectric_point = SeqUtils.isoelectric_point(protein_sequence)
        return {
            'aa_count': aa_count,
            'molecular_weight': molecular_weight,
            'isoelectric_point': isoelectric_point,
        }

class IoTControl:
    def collect_data(self):
        data = {
            'temperature': 30 * random() + 20,
            'humidity': 50 * random() + 30,
            'pressure': 1000 * random() + 900,
        }
        return data

    def control_device(self, device, command):
        return f"Sent command '{command}' to device '{device}'."

bio_crypto = BioCrypto("MySecurePassword", "AES")
iot_control = IoTControl()

message = "Hello, World!"
encrypted_data = bio_crypto.encrypt(message)
decrypted_message = bio_crypto.decrypt(
    encrypted_data['ciphertext'],
    encrypted_data['salt'],
    encrypted_data['iv']
)

print(f"Original Message: {message}")
print(f"Decrypted Message: {decrypted_message}")

seq1 = Seq("ACGTAGTACGTAGTACGTAGT")
seq2 = Seq("TACGTACGTACGTACGTACGT")
alignment = bio_crypto.align_sequences(seq1, seq2)
print(alignment)

sequence = Seq("ATGCGCATGACGATGCTAGCTAGCATG")
motif_pattern = "ATG"
motif_result = bio_crypto.find_motif(sequence, motif_pattern)
print(f"Motif found at positions: {', '.join(map(str, motif_result)))}")

dna_sequence = "ATGGCTTAGCTGCTAGCTAGCTAGC"
protein_sequence = bio_crypto.translate_sequence(dna_sequence)
print(f"Translated Protein Sequence: {protein_sequence}")

rc_dna_sequence = bio_crypto.reverse_complement(dna_sequence)
print(f"Reverse Complement DNA: {rc_dna_sequence}")

protein_info = bio_crypto.analyze_protein_sequence(protein_sequence)
print(f"Amino Acid Count: {protein_info['aa_count']}")
print(f"Molecular Weight: {protein_info['molecular_weight']}")
print(f"Isoelectric Point: {protein_info['isoelectric_point']}")

iot_data = iot_control.collect_data()
print("Collected IoT Data:")
for key, value in iot_data.items():
    print(f"{key}: {value}")

device = "IoTDevice1"
command = "TurnOn"
control_result = iot_control.control_device(device, command)
print(f"IoT Control Result: {control_result}")
