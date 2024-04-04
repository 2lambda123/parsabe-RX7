
# RX7

RX7 is a Python script that demonstrates various functionalities, including bioinformatics tasks, data encryption/decryption, and simulated IoT data collection and control.

## Features

### Bioinformatics

- **Sequence Alignment:** Align DNA sequences using ClustalW from the BioPerl library.
- **Motif Finding:** Find motifs in DNA sequences.
- **Translation:** Translate DNA sequences to protein sequences.
- **Reverse Complement:** Calculate the reverse complement of DNA sequences.
- **Protein Sequence Analysis:** Analyze protein sequences for amino acid count, molecular weight, and isoelectric point.

### Encryption/Decryption

- **Data Encryption:** Encrypt sensitive data using AES encryption.
- **Data Decryption:** Decrypt encrypted data with a password.

### IoT (Internet of Things) Simulation

- **Data Collection:** Simulate data collection from IoT sensors (temperature, humidity, and pressure).
- **Device Control:** Simulate sending commands to IoT devices.

## Dependencies

To run this script, you'll need to have the following Perl modules installed:

- Crypt::Cipher
- Crypt::PBKDF2
- Crypt::Random
- MIME::Base64
- Storable
- BioPerl (Bio::Seq, Bio::Tools::Run::Alignment::Clustalw, Bio::Tools::Motif, Bio::Tools::IUPAC, Bio::SeqUtils)

You can install these modules using CPAN or your preferred package manager.

## Usage

1. Clone this repository to your local machine:

```bash
git clone https://github.com/yourusername/RX7.git
cd RX7
```

2. Install the required Perl modules if you haven't already:

```bash
# Example installation using CPANM
cpanm Crypt::Cipher Crypt::PBKDF2 Crypt::Random MIME::Base64 Storable BioPerl
```

3. Run the Perl script:

```bash
python main.py
```

Replace `rx7.pl` with the actual name of your Perl script.

4. Follow the prompts to interact with the script. You can perform bioinformatics tasks, encrypt and decrypt data, and simulate IoT data collection and control.

