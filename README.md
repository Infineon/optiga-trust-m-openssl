[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

[![REUSE status](https://api.reuse.software/badge/github.com/infineon/optiga-trust-m-openssl)](https://api.reuse.software/info/github.com/infineon/optiga-trust-m-openssl)

# Infineon OpenSSL Interface implementation for OPTIGA™ Trust M Host Library

- [Infineon OpenSSL Interface implementation for OPTIGA™ Trust M Host Library](#infineon-openssl-interface-implementation-for-optiga-trust-m-host-library)
  - [Prerequisites](#prerequisites)
  - [Getting Started](#getting-started)
    - [Getting the Code from GitHub](#getting-the-code-from-github)
    - [First time building the library](#first-time-building-the-library)
  - [OPTIGA™ Trust V3 OpenSSL Provider usage](#optiga-trust-v3-openssl-provider-usage)
    - [rand](#rand)
    - [req](#req)
    - [pkey](#pkey)
      - [KeyGen with public key as output](#keygen-with-public-key-as-output)
      - [KeyGen with Reference Keys in file format as output ](#keygen-with-reference-keys-in-file-format-as-output)
    - [pkeyutl](#pkeyutl)
      - [Sign using Labels with key id](#sign-using-labels-with-key-id)
      - [Sign using Reference Keys in file format ](#sign-using-reference-keys-in-file-format)
    - [Referencing keys in OPTIGA™ Trust M](#referencing-keys-in-optiga-trust-m)
    - [Testing TLS connection with ECC key](#test_tls_ecc)
      - [Scenario where OPTIGA™ Trust M is on the client ](#test_tls_ecc_client)
      - [Scenario where OPTIGA™ Trust M is on the server ](#test_tls_ecc_server)
      - [Testing TLS connection with ECC Reference key in file format](#test_tls_ecc_file)
      - [Testing Curl connection using ECC Reference key in file format](#test_curl_ecc_file)
    - [Testing TLS connection with RSA key](#test_tls_rsa)
      - [Scenario where OPTIGA™ Trust M is on the client](#test_tls_rsa_client)
      - [Scenario where OPTIGA™ Trust M is on the server](#test_tls_rsa_server)
    - [Generating a Test Server Certificate](#generating-a-test-server-certificate)
    - [Using OPTIGA™ Trust M OpenSSL provider to sign and issue certificate](#using-optiga-trust-m-openssl-provider-to-sign-and-issue-certificate)
      - [Generating CA key pair and Creating OPTIGA™ Trust M CA self sign certificate](#generating-ca-key-pair-and-creating-optiga-trust-m-ca-self-sign-certificate)
      - [Generating a Certificate Request (CSR)](#generating-a-certificate-request-csr)
      - [Signing and issuing the Certificate with Trust M](#signing-and-issuing-the-certificate-with-trust-m)

## <a name="prerequisites"></a>Prerequisites

This tool was tested on the following hardware platforms and boards:

* Raspberry PI 4  on Linux kernel >= 5.15

* Micro SD card (≥16GB)

* [OPTIGA™ Trust M MTR SHIELD](https://www.infineon.com/cms/en/product/evaluation-boards/trust-m-mtr-shield/) paired with [Pi Click Shield](https://www.mikroe.com/pi-4-click-shield) 

* [S2GO SECURITY OPTIGA™ Trust M](https://www.infineon.com/cms/en/product/evaluation-boards/s2go-security-optiga-m/)  paired with [Shield2Go Adapter for Raspberry Pi](https://www.infineon.com/cms/en/product/evaluation-boards/s2go-adapter-rasp-pi-iot/)

  

  Note: OPTIGA™ Trust M Provider was tested on Linux raspberrypi 6.6.51+rpt-rpi-v8 aarch64 with OpenSSL 3.0.17 pre-installed

**Hardware connection:**

**I2C Connection**: Below table shows the I2C connection between the [OPTIGA™ Trust M](https://www.infineon.com/cms/en/product/evaluation-boards/trust-m-mtr-shield/) and Raspberry Pi(RPI).

|  No  | Description | RPI Pin # | Pin Description |
  | :--: | :---------: | :-------: | :-------------: |
  |  1   |   I2C SCL   |     5     |    SCL1, I2C    |
  |  2   |   I2C SDA   |     3     |    SDA1, I2C    |
  |  3   |     VCC     |    17     |       3V3       |
  |  4   |     GND     |     9     |       GND       |

![](/data/images/rpi_mikro_connection.png)

​       Figure 1 Hardware Setup for OPTIGA™ Trust M MTR SHIELD using Pi Click Shield

![](data/images/HardwareSetup.png)

​	Figure 2 Hardware Setup for S2GO SECURITY OPTIGA™ Trust M using Shield2Go Adapter



## <a name="getting_started"></a>Getting Started

### <a name="getting_code"></a>Getting the Code from GitHub

Getting the initial code from GitHub with submodules 


```
git clone --recurse-submodules https://github.com/Infineon/optiga-trust-m-openssl.git 
```

### <a name="build_lib"></a>First time building the library
Run the commands below in sequence to install the required dependencies and the OPTIGA™ Trust M provider. 

    cd optiga-trust-m-openssl
    ./trustm_installation_script.sh

Note: 

Enable I2C interface for Raspberry Pi to communicate with OPTIGA™ Trust M

## <a name="provider_usage"></a>OPTIGA™ Trust M OpenSSL Provider usage

### <a name="rand"></a>rand

Usage : Random number generation
Example

```console 
openssl rand -provider trustm_provider -base64 32
```
*Note :* 
*If OPTIGA™ Trust M random number generation fails, there will still be random number output.* 
*This is controlled by OpenSSL provider do not have control over it.*

### <a name="req"></a>req
Usage : Certificate request / self signed cert / key generation

OPTIGA™ Trust M provider uses the -key parameter to pass input to the key generation/usage function.

Following is the input format:

-key **OID** : **public key input** : **NEW** :**key size** : **key usage**

where :

- **OID** for OPTIGA™ Trust M key

  - if OID 0xE0F0 is used no other input is needed
- **public key input**

  - public key file name in PEM format

  - \* = no public input

  - ^ = public key store in Application OID Key

    - 0xE0F1 store in 0xF1D1,

    - 0xE0F2 store in 0xF1D2,

    - 0xE0F3 store in 0xF1D3,

    - 0xE0FC store in 0xF1E0,

    - 0xE0FD store in 0xF1E1

      Note: For ECC521/BRAINPOOL512, the public key store in Application OID list as below:

    - 0xE0F1 store in 0xF1E0,

    - 0xE0F2 store in 0xF1E1
  
- **NEW**

  - Generate new key pair in OPTIGA™ Trust M
- **key size**

  - ECC
    - 0x03 = 256 key length  for NIST  256
    - 0x04 = 384 key length  for NIST  384
    - 0x05 = 521 key length  for NIST  521
    - 0x13 = 256 key length  for brainpoolP256r1
    - 0x15 = 384 key length  for brainpoolP384r1
    - 0x16 = 512 key length  for brainpoolP512r1
  - RSA
    - 0x41 = 1024 key length
    - 0x42 = 2048 key length
- **Key usage** 

  - Auth : 0x01 
  - Enc : 0x02 
  - HFWU : 0x04 
  - DevM : 0X08 
  - Sign : 0x10 
  - Agmt : 0x20

*Note: If wrong public is submitted the certificate generation will still go through but verification will fail.*

Example : Generating a certificate request using OID 0xE0F3 with new key generated, ECC 384 key length and Auth/Enc/Sign usage. Verify that public key match the private key in the OID.

```console 
openssl req -provider trustm_provider -key 0xe0f3:*:NEW:0x04:0x13 -new -out test_e0f3.csr -verify
```
*Note:*
*If wrong public key is used or no public key is submitted, the certificate generation will still* 
*go through but verification will fail. Public key input only in PEM*

### <a name="pkey"></a>pkey
Usage : Key generation

OPTIGA™ Trust M provider uses the -in parameter to pass input to the key generation function.

Following is the input format:

-in **OID** : **public key input** : **NEW** :**key size** : **key usage**

(see [req](#req) for input details)

There are two ways to generate New ECC/RSA Key Pair. 

#### KeyGen with public key as output 

Example: To generate keypair with public key as output and private key stored inside OPTIGA™ Trust M:

```console 
openssl pkey -provider trustm_provider -in 0xe0f1:*:NEW:0x03:0x13 -pubout -out e0f1_pub.pem
```

The above command will generate one ECC 256 keypair in OPTIGA™ Trust M. The output (e0f1_pub.pem) is the public key and private key is stored inside OPTIGA™ Trust M. Refer to [Referencing keys in OPTIGA™ Trust M](#referencing-keys-in-optiga-trust-m)  Section for more details.

#### KeyGen with Reference Keys in file format as output

Example: To generate reference keys in file format for ECC 256:

```console 
openssl pkey -provider trustm_provider -provider default -propquery provider=trustm -in 0xe0f1:*:NEW:0x03:0x13 -out ecc256_key.pem
```

The above command will generate one ECC 256 keypair in OPTIGA™ Trust M. The private key id and  public key of OPTIGA™ Trust M are stored inside the output file (ecc256_key.pem). Refer to  [Referencing keys in OPTIGA™ Trust M](#referencing-keys-in-optiga-trust-m)  Section for more details.

### <a name="pkeyutl"></a>pkeyutl
Usage : Sign and verify

#### Sign using Labels with key id

Example for signing using Labels with key id.

Signing the message in the test_sign.txt file using the OPTIGA™ Trust M ECC key and saving the generated signature in the test_sign.sig file.

```console 
openssl pkeyutl -provider trustm_provider -inkey 0xe0f1:^  -sign -rawin -in test_sign.txt -out test_sign.sig
```

Verifying the signature of the raw input data in test_sign.txt using the provided public key in eofd_pub.pem and the signature in test_sign.sig

```console 
openssl pkeyutl -verify -pubin -inkey e0f1_pub.pem -rawin -in test_sign.txt -sigfile test_sign.sig
```

For more details, please refer to  [ec_keygen_and_sign](./examples/scripts/ec_keygen_and_sign/).

#### Sign using Reference Keys in file format

Example for Signing using Reference Keys in file format.

Signing the message in the test_sign.txt file using Reference Keys in file format and saving the generated signature in the test_sign.sig file.

```console 
openssl pkeyutl -provider trustm_provider -provider default -sign -rawin -inkey ecc256_key.pem -in test_sign.txt -out test_sign.sig
```

Verifying the signature of the raw input data in test_sign.txt using the provided public key in eofd_pub.pem and the signature in test_sign.sig

```console 
openssl pkeyutl -verify -pubin -inkey e0fd_pub.pem -rawin -in test_sign.txt -sigfile test_sign.sig
```

For more details, please refer to  [ec_sign_verify_pem_files](./examples/scripts/ec_sign_verify_pem_files/).

### <a name="referencing-keys-in-optiga-trust-m"></a>Referencing keys in OPTIGA™ Trust M

The keys created inside OPTIGA™ Trust M can be referenced in two different ways

1. Labels with key id. Example - 0xe0f1:
2. Reference Keys in file format

### 1. Labels with key id

In this method, the 2-byte key ID of the private key created / stored in OPTIGA™ Trust M is passed in string format.

Example - 0xe0f1:

### 2. Reference Keys in file format

The cryptographic functionality offered by the OpenSSL provider requires a reference to a key stored inside the secure element (exception is random generation).

OpenSSL requires a key pair, consisting of a private and a public key, to be loaded before the cryptographic operations can be executed. This creates a challenge when OpenSSL is used in combination with a secure element as the private key cannot be extracted out from the secure element.

The solution is to populate the OpenSSL Key data structure with only a reference to the private key inside the secure element instead of the actual private key. The public key as read from the secure element can still be inserted into the key structure.

OpenSSL crypto APIs are then invoked with these data structure objects as parameters. When the crypto API is routed to the provider, the Trust M provider implementation decodes these key references and invokes the secure element APIs with correct key references for a cryptographic operation. If the input key is not a reference key, execution will roll back to OpenSSL software implementation.

``NOTE: When using this method, the Trust M provider has to be loaded first. This will ensure that Trust M provider can decode the key id information present in the reference key.``


#### EC Reference Key Format

The following provides an example of an EC reference key. The value reserved
for the private key has been used to contain:

-  a 16 bit key identifier (in the example below ``0xe0f1``)

```console
Private-Key: (256 bit)
priv:
    e0:f1:00:00:00:00:00:00:00:00:00:00:00:00:00:
    00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:
    00:00
pub:
    04:68:ba:d2:d6:23:b5:0d:fa:41:4e:8a:73:f7:d6:
    c5:08:13:92:49:28:b6:13:24:ff:2c:2e:02:4f:c5:
    a1:57:46:6f:f6:9e:1c:62:77:a4:42:fd:ce:66:06:
    d5:76:0d:95:0a:00:fe:7c:b0:ad:5c:91:73:61:c1:
    38:33:cc:4a:03
ASN1 OID: prime256v1
NIST CURVE: P-256
```

- Ensure the value reserved for public key and ASN1 OID contain the values
  matching the stored key.

---

#### RSA Reference Key Format

The following provides an example of an RSA reference key.

-  The value reserved for 'p' ('prime1') is used as a magic number and is
   set to '1'
-  The value reserved for 'q' ('prime2') is used to store the 16 bit key
   identifier (in the example below 0xe0fc)

```console
Private-Key: (2047 bit, 2 primes)
modulus:
    47:ee:f4:a5:fc:63:d5:93:04:21:c0:86:eb:09:b0:
    6d:9f:2b:28:1c:63:9a:2a:64:89:07:30:9e:2f:f3:
    02:55:e3:6c:8c:87:91:29:27:ed:a3:76:ab:1d:7d:
    f0:d8:e8:b2:b8:e2:83:af:6b:e3:e5:3b:0f:c8:3e:
    cf:8b:7a:79:6d:1a:ab:f5:41:b6:94:70:ad:2b:33:
    60:08:e0:4f:ab:9c:70:2a:a0:87:da:fd:4a:ef:f7:
    b8:d2:03:d1:c6:d0:39:5a:e8:de:d3:80:af:5f:fe:
    63:01:7a:24:9d:a5:2b:29:a4:7c:61:a4:74:dd:37:
    96:05:7f:7a:b0:3b:5b:b8:a5:72:fa:1f:14:d5:72:
    66:00:be:e6:cd:a4:9e:3e:70:23:88:fd:38:48:b0:
    04:80:4e:73:77:dc:fc:75:a5:38:c2:b8:ce:82:8e:
    d7:8e:33:f5:3f:63:e3:dd:4c:07:a0:70:f4:8a:a1:
    ff:15:2a:9d:ba:af:9c:98:4c:b4:a2:21:a3:a0:22:
    3f:67:66:4a:9d:6f:0c:6e:4a:49:97:d0:27:af:3f:
    3f:40:7f:9b:7e:5d:0a:91:cc:95:1a:30:19:be:87:
    c4:3f:c7:c9:a9:65:10:ad:d5:17:b6:af:78:e1:a5:
    8c:07:50:8d:9b:9f:c7:3b:7f:9e:b1:2c:da:11:2b:
    a1
publicExponent: 65537 (0x10001)
privateExponent: 0
prime1: 1 (0x1)
prime2: 57596 (0xe0fc)
exponent1: 0
exponent2: 0
coefficient: 0
```

---

- Ensure key length, the value reserved for (private key) modulus and
  public exponent match the stored key.
- Setting prime1 to '1' makes it impossible that a normal private key
  matches a reference key.
- The mathematical relation between the different key components is not
  preserved for this reference key pem file.

### <a name="test_tls_ecc"></a>Testing TLS connection with ECC key

#### <a name="test_tls_ecc_client"></a>Scenario where OPTIGA™ Trust M is on the client :

*Note : To generate a test server certificate refer to [Generating a Test Server Certificate](#test_Server_cert)*  or refer below

Generate Server ECC Private Key on Trust M

```
openssl ecparam -out server1_privkey.pem \
-name prime256v1 -genkey
```

Generate CSR for Server 

```
openssl req -new -key server1_privkey.pem \
-subj "/C=SG/CN=Server1/O=Infineon" \
-out server1.csr
```

Generate Server certificate using CA

```
openssl x509 -req -in server1.csr \
-CA scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-CAkey scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA_Key.pem \
-CAcreateserial -out server1.crt \
-days 365 \
-sha256 \
-extfile ../openssl.cnf -extensions cert_ext
```

Create new ECC 256 key length and Auth/Enc/Sign usage and generate a certificate request for OPTIGA™ Trust M key 0xE0F1

```console
openssl req -provider trustm_provider \
-key 0xe0f1:*:NEW:0x03:0x13 \
-new -out test_e0f1.csr \
-subj "/C=SG/CN=TrustM/O=Infineon"
```

Extract the public key from certificate request for OPTIGA™ Trust M key 0xE0F1

```
openssl req -in client1_e0f1.csr \
-pubkey -noout \
-out client1_e0f1.pub
```

Issue the certificate with keyUsage=digitalSignature,keyEncipherment on the client side with OPTIGA_Trust_M_Infineon_Test_CA.

*Note : Refer to [Generating a Test Server Certificate](#test_Server_cert)  for openssl.cnf*

```console
openssl x509 -req -in test_e0f1.csr \
-CA scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-CAkey scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA_Key.pem \
-CAcreateserial \
-out test_e0f1.crt \
-days 365 \
-sha256

```

Running the test server : 

```console
lxterminal -e openssl s_server \
-cert server1.crt \
-key privkey.pem \
-accept 5000 \
-verify_return_error \
-Verify 1 \
-CAfile scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem

```

Running the test client : *(open a new console)* 

```console
lxterminal -e openssl s_client \
-connect localhost:5000 \
-servername Server1 \
-provider trustm_provider \
-provider default \
-cert test_e0f1.crt \
-key 0xe0f1:^ \
-CAfile scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem

```

#### <a name="test_tls_ecc_server"></a>Scenario where OPTIGA™ Trust M is on the server :

Create new ECC 256 key length and Auth/Enc/Sign usage and generate a certificate request for OPTIGA™ Trust M key 0xE0F2

```console
openssl req -provider trustm_provider \
-key 0xe0f2:*:NEW:0x03:0x13 -new \
-out test_e0f2.csr \
-subj "/C=SG/CN=TrustM/O=Infineon"
```

Extract Public Key from certificate request for OPTIGA™ Trust M key 0xE0F2

```
openssl req -in test_e0f2.csr \
-pubkey -noout \
-out test_e0f2.pub
```

Issue the certificate with keyUsage=keyCertSign, cRLSign, digitalSignature on the server side with OPTIGA_Trust_M_Infineon_Test_CA.

```console
openssl x509 -req -in test_e0f2.csr \
-CA scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-CAkey scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA_Key.pem \
-CAcreateserial \
-out test_e0f2.crt \
-days 365 \
-sha256 \
-extfile openssl.cnf \
-extensions cert_ext
```

Generate Client ECC Private Key

```
openssl ecparam -out privkey.pem \
-name prime256v1 -genkey
```

Generate Client CSR

```
openssl req -new \
-key privkey.pem \
-subj "/C=SG/CN=Server1/O=Infineon" \
-out client.csr
```

Generate Client certificate using CA

```
openssl x509 -req -in client.csr \
-CA scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-CAkey $CERT_PATH/OPTIGA_Trust_M_Infineon_Test_CA_Key.pem \
-CAcreateserial -out client.crt \
-days 365 \
-sha256
```

Running the test server : 

```console
lxterminal -e openssl s_server \
-cert test_e0f2.crt \
-provider trustm_provider -provider default \
-key 0xe0f2:^ \
-accept 5000 \
-verify_return_error \
-Verify 1 \
-CAfile scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem

```

Running the test client : *(open a new console)* 

```console
lxterminal -e openssl s_client \
-connect localhost:5000 \
-servername Server1 \
-cert client.crt \
-key privkey.pem \
-CAfile scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem

```

#### <a name="test_tls_ecc_file"></a>Testing TLS connection with ECC Reference key in file format

Please refer to  [ec_server_client_pem_file](./examples/scripts/ec_server_client_pem_file/) for detailed use cases.

#### <a name="test_curl_ecc_file"></a>Testing Curl  connection using ECC Reference key in file format

Please refer to  [trustm_curl_test](./examples/scripts/trustm_curl_test/) for detailed use cases.

### <a name="test_tls_rsa"></a>Testing TLS connection with RSA key

#### <a name="test_tls_rsa_client"></a>Scenario where OPTIGA™ Trust M is on the client :

*Note : To generate a test server certificate refer to [Generating a Test Server Certificate](#test_server_cert)* 

Creates new RSA 2048 key length and Auth/Enc/Sign usage and generate a certificate  request for OPTIGA™ Trust M key 0xE0FC

```console
openssl req -provider trustm_provider \
-key 0xe0fd:*:NEW:0x42:0x13 \
-new \
-subj "/C=SG/CN=TrustM/O=Infineon" \
-out test_e0fd.csr
```

Issue the certificate with keyUsage=digitalSignature,keyEncipherment on the client side with OPTIGA_Trust_M_Infineon_Test_CA.

**Note : Refer to [Generating a Test Server Certificate](#test_server_cert)  for openssl.cnf**

```console
openssl x509 -req -in test_e0fd.csr \
-CA scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-CAkey scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA_Key.pem \
-CAcreateserial \
-out test_e0fd.crt \
-days 365 \
-sha256 \
-extfile openssl.cnf \
-extensions cert_ext1
```

Running the test server : 

```console
openssl s_server \
-cert test_opensslserver.crt \
-key privkey.pem -accept 5000 \
-verify_return_error \
-Verify 1 \
-CAfile scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-sigalgs RSA+SHA256
```

Running the test client : *(open a new console)* 

```console
openssl s_client -provider trustm_provider -provider default \
-client_sigalgs RSA+SHA256 \
-cert test_e0fd.crt \
-key 0xe0fd:^ \
-connect localhost:5000 \
-tls1_2 \
-CAfile scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-verify 1 
```

#### <a name="test_tls_rsa_server"></a>Scenario where OPTIGA™ Trust M is on the server :

Creates new RSA 2048 key length and Auth/Enc/Sign usage and generate a certificate  request for OPTIGA™ Trust M key 0xE0FD

```console
openssl req -provider trustm_provider -key 0xe0fc:*:NEW:0x42:0x13 -new -subj "/C=SG/CN=TrustM/O=Infineon" -out test_e0fc.csr
```

Issue the certificate with keyUsage=keyCertSign, cRLSign, digitalSignature on the server side with OPTIGA_Trust_M_Infineon_Test_CA.

```console
openssl x509 -req -in test_e0fc.csr -CA  scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-CAkey scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA_Key.pem \
-CAcreateserial \
-out test_e0fc.crt \
-days 365 \
-sha256 \
-extfile openssl.cnf \
-extensions cert_ext2
```

Running the test server : 

```console
openssl s_server -provider trustm_provider -provider default \
-cert test_e0fc.crt \
-key 0xe0fc:^ \
-accept 5000 \
-verify_return_error \
-CAfile scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-sigalgs RSA+SHA256 
```

Running the test client : *(open a new console)* 

```console
openssl s_client \
-CAfile scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-connect localhost:5000 -tls1_2
-client_sigalgs RSA+SHA256
```

### <a name="test_server_cert"></a>Generating a Test Server Certificate

Generate a new key pair and certificate request using OpenSSL command:

```console
openssl req -new -nodes -subj "/C=SG/O=Infineon" -out test_opensslserver.csr
```

Creates the openssl.cnf with the below contain:

```console
cat openssl.cnf 
```

Creates and displays the openssl.cnf as shown below:

```console
[ cert_ext ]
subjectKeyIdentifier=hash
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=clientAuth,serverAuth

[ cert_ext1 ]
subjectKeyIdentifier=hash
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=clientAuth

[ cert_ext2 ]
subjectKeyIdentifier=hash
keyUsage=keyCertSign, cRLSign, digitalSignature
```

Issue the certificate with keyUsage=keyCertSign, cRLSign, digitalSignature on the server side with OPTIGA_Trust_M_Infineon_Test_CA.

```console
openssl x509 -req -in test_opensslserver.csr \
-CA scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem \
-CAkey scripts/certificates/OPTIGA_Trust_M_Infineon_Test_CA_Key.pem \
-CAcreateserial \
-out test_opensslserver.crt \
-days 365 \
-sha256 \
-extfile openssl.cnf \
-extensions cert_ext2
```



### <a name="issue_cert"></a>Using OPTIGA™ Trust M OpenSSL provider to sign and issue certificate

In this section, we will demonstrate how to use OPTIGA™ Trust M OpenSSL provide to enable OPTIGA™ Trust M as a simple Certificate Authorities (CA) without revocation and tracking of certificate it issue.

#### Generating CA key pair and Creating OPTIGA™ Trust M CA self sign certificate

Create OPTIGA™ Trust M CA key pair with the following parameters:

- OID 0xE0F2
- Public key store in 0xF1D2
- Self signed CA cert with subject
  - Organization : Infineon OPTIGA(TM) Trust M
  - Common Name : UID of Trust M
  - expiry days : ~10 years

```console
openssl req -provider trustm_provider -provider default \
-key 0xe0f2:^:NEW:0x03:0x13 \
-new \
-x509 \
-days 3650 \
-subj /O="Infineon OPTIGA(TM) Trust M"\
-sha256 \
-extensions v3_req \
-out test_e0f2.crt \
```

#### Generating a Certificate Request (CSR)

You may use the example given in [req](#req) to generate a CSR or use any valid CSR

or

Use the following command to generate an Elliptic Curve Cryptography (ECC) keypair.

```
openssl ecparam \
-out dev_privkey.pem \
-name prime256v1 \
-genkey
```

Following command generates a CSR, which is a request to a Certificate Authority (CA) to sign the public key along with the information provided. The CSR contains the public key from the private key file and the subject information.

```
openssl req -new \
-key dev_privkey.pem \
-subj /CN=TrustM_Dev1/O=Infineon/C=SG \
-out test_e0f3.csr
```

These scripts are part of the initial steps for setting up a secure communication channel, enabling the device or server to prove its identity to clients or other servers. The CSR would typically be sent to a CA, who verifies the information and issues a certificate, which can then be used in SSL/TLS handshakes.

#### Signing and issuing the Certificate with Trust M

Following demonstrate how you can issue and sign certificate with OPTIGA™ Trust M with the following inputs:

- input csr file : test_e0f3.csr
- CA Cert : test_e0f2.crt
- CA key : 0xE0F2 with public key store in 0xF1D2
- Create new serial number for certificate (serial number is store in test_e0f3.srl)
- using extension cert_ext in extension file
- expiry days : 1 year

*Note : Refer to [Generating a Test Server Certificate](#test_Server_cert)  for openssl.cnf*

```console
openssl ca -batch -create_serial \
-provider trustm_provider -provider default \
-keyfile 0xe0f2:^ \
-in test_e0f3.csr \
-out test_e0f3.crt \
-cert test_e0f2.crt \
-days 365 \
-config openssl.cnf \
-md sha256
```