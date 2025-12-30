{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

Authors:      Arno Garrels
              Angus Robertson <delphi@magsys.co.uk>
Creation:     Aug 26, 2007
Description:  SSL key and X509 certification creation
Version:      V9.5
EMail:        francois.piette@overbyte.be  http://www.overbyte.be
Support:      https://en.delphipraxis.net/forum/37-ics-internet-component-suite/
Legal issues: Copyright (C) 2007-2025 by François PIETTE
              Rue de Grady 24, 4053 Embourg, Belgium.

              This software is provided 'as-is', without any express or
              implied warranty.  In no event will the author be held liable
              for any  damages arising from the use of this software.

              Permission is granted to anyone to use this software for any
              purpose, including commercial applications, and to alter it
              and redistribute it freely, subject to the following
              restrictions:

              1. The origin of this software must not be misrepresented,
                 you must not claim that you wrote the original software.
                 If you use this software in a product, an acknowledgment
                 in the product documentation would be appreciated but is
                 not required.

              2. Altered source versions must be plainly marked as such, and
                 must not be misrepresented as being the original software.

              3. This notice may not be removed or altered from any source
                 distribution.

              4. You must register this software by sending a picture postcard
                 to the author. Use a nice stamp and mention your name, street
                 address, EMail address and any comment you like to say.

History:
Jun 30, 2008 A.Garrels made some changes to prepare SSL code for Unicode.
Jun 30, 2008 A.Garrels added some RSA and Blowfish crypto functions.
Jul 11, 2008 v1.01 RTT <pdfe@oniduo.pt> contributed function CreateCertRequest(),
             slightly modified by A. Garrels.
Jan 29, 2009 V1.03 A.Garrels added overloads which take UnicodeStrings to
             CreateCertRequest() and CreateSelfSignedCert() in D2009 and better.
             Both functions now create UTF-8 certificate fields if they contain
             characters beyond the ASCII range.
Apr 24, 2011 V1.04 Record TEVP_PKEY_st changed in OpenSSL 1.0.0 and had to be
             declared as dummy. Use new functions from OverbyteIcsLibeay to
             make this unit compatible with OpenSSL 1.0.0+.
Apr 24, 2011 V1.05 Include OverbyteIcsTypes.pas to make inlining work.
Nov 12, 2013 V1.06 Angus allow private key and certificate to be saved to separate files
Feb 14, 2014 V1.07 Angus added class TX509Ex derived from TX509Base adding
             properties for most common certificate entries including extensions
             Optionally add clear text comments to PEM files to easily identify
             certifcates.
Apr 18, 2014 V1.07a Arno removed some compiler warnings.
Jul 07, 2014 V1.08 Angus improved certificate comment
June 2015    Angus moved to main source dir
Oct 25, 2015 V1.09 Angus added SignatureAlgorithm property to TX509Ex so we can check
             certificates are SHA256, also KeyInfo, SerialNumHex
             CertInfo provides multiline string of main certificate information for logging
Nov 5, 2015  V8.20 Angus removed a compiler warning, version matches wsocket
Mar 17, 2015 V8.21 Angus use SHA256 for unicode self signed and non-unicode request
May 24, 2016 V8.27 Angus, initial support for OpenSSL 1.1.0
Aug 27, 2016 V8.32 Angus, moved sslRootCACertsBundle long constant from twsocket and
               split smaller and make function so it will compile under C++ Builder
Oct 18, 2016 V8.35 Angus, no longer need OverbyteIcsLibeayEx
             added CreateRsaKeyPair
Oct 26, 2016  V8.36 Now using new names for imports renamed in OpenSSL 1.1.0
Nov 22, 2016  V8.39 Moved TX509Ex properties into TX509Class in OverbyteIcsWSocket
Jan 27, 2017  V8.40 Angus New TSslCertTools component to create and sign certificates
              Create Elliptic Curve/ECDSA private keys
              Create certificate request from old certificate
              Sign certificate requests as CA
              Create DHParam files
              Add alternate extended properties to certs, DNS and IP addresses
              Added TEvpCipher and TEvpDigest (hash) types supported by OpenSSL
              Display Sha1Hex in General certificate as Fingerprint
Feb 24, 2017  V8.41 Added CreateCertBundle to build a new PEM or PKCS12 file
                 combining certificate, private key and intermediate files
              Added more certificate request extension properties including alt domains
              Creating requests now adds alternate domains, IP addresses, etc
              Create certificate from request now optionally copies extensions
              The old CreateCertRequest and CreateSelfSignedCert functions now
                 use the TSslCertTools component and provide backward compatibitity
Mar 3, 2017  V8.42 Angus TULargeInteger now ULARGE_INTEGER
Jun 21, 2017 V8.49 Added ISRG Root X1 certificate for Let's Encrypt
             Fixed AV creating second EC key (OpenSSL function fails)
             Now creating X25519 Elliptic Curve private keys
             Total rewrite creating private keys using EVP_PKEY_CTX functions
Sep 22, 2017 V8.50 Alternate DNS names now added correctly to requests and certs
             Corrected X25519 private keys to ED25519, requires OpenSSL 1.1.1
Nov 3, 2017  V8.51 Tested ED25519 keys, can now sign requests and certs
             Added RSA-PSS keys and SHA3 digest hashes, requires OpenSSL 1.1.1
Feb 21, 2018 V8.52 Added DigiCert Global Root G2 and G3 root certificates
             Added key and signature to ReqCertInfo
             Added SaveToDERText
Mar 27, 2018 V8.53 Added GlobalSign Root CA - R2 and GlobalSign ECC Root CA - R5
                root certificates, R2 used by Google.
             Added DST Root CA X3 root, used by Let's Encrypt crossed signing
Oct 2, 2018  V8.57 tidy up UnwrapNames.
             DoSelfSignCert can now use a CSR instead of properties
             Added DoClearCA
             Added SaveToCADatabase which saves CA database entry to CADBFile
             Added COMODO ECC Certification Authority root
             Build with FMX
Aug 07, 2019 V8.62  Added literals for various types to assist apps.
             Added AcmeIdentifier property for ACME validation certificate
             Builds without USE_SSL
Oct 24, 2019 V8.63 Added 'Starfield Services Root Certificate Authority - G2'
               (used by Amazon buckets), and 'Amazon Root CA 1', CA 2, CA 3,
               CA 4 which are replacing Starfield.  Removed expired certs.
May 18, 2020 V8.64 DoKeyPair raises exception for unknown key type.
              CreateSelfSignedCert ignored Days and always created 7 day expiry.
              Added support for International Domain Names for Applications (IDNA),
                i.e. using accents and unicode characters in domain names.
              X509 certificates always have A-Lavels (Punycode ASCII) domain names,
                never UTF8 or Unicode.
              CreateRsaKeyPair uses Unicode file names, as do all other SSL
                certificate functions (through IcsSslOpenFileBio).
              Added CreateSelfSignCertEx to create self signed certificates with
                 subject alternate names and specific key type, used by TSocketServer
                 to start servers with missing certificates.
              Renamed SaveToDERText to SaveReqToDERText for clarity, added
                SaveCertToDERText.
              Added root 'AAA Certificate Services' for Comodo, aka Sectigo.
              Simplified building alternate subject name extensions so that both
                DNS and IP Address can be used together, and IP address is now
                saved correctly.
              ClearAltStack dies on Win64 so suppressed part of the code until
                work out why.
Sep 03, 2020  V8.65 Clear TX509Base safely.
              Fixed four corrupted root certificates, two had 8-bit comment
                characters that caused problems if Windows was set to read UTF8,
                so suppressed all comments which also saves apace.
              All sslRootCACerts0xx constants now generated by rootcatool.exe
                 application to avoid errors, removed three old certificates
                 and added another Go Daddy.
              Write comments as UTF8 to certificate request file.
              Posix fixes.
Mar 16, 2021  V8.66 Renamed all OpenSSL functions to original names removing ICS
                     f_ prefix.
              Added support for YuOpenSSL which provides OpenSSL in a pre-built
                 DCU linked into applications, rather than using external DLLs.
              Removed support for OpenSSL 1.0.2 and 1.1.0 whose support ceased Dec 2019.
Sep 30, 2021  V8.67 OpenSSL 3.0 makes several old ciphers and digests legacy so
                 default for encrypting private key files is now PrivKeyEncAES256.
              Updated root certificate bundle, one old cert gone.
              Added new Let's Encrypt ECDSA X2 root not yet in public bundles.
              Create private key pair with PrivKeyECsecp256k kobitz curve.
              Added TSslCertTools GetKeyParams get specified key parameters for
                OpenSSL 3.0 and later.
Nov 05, 2021 V8.68 Removed DST Root CA X3 certificate which expired 30 Sept 2021.
              Support OpenSSL 3.0 for YuOpenSSL.
              Updated sslRootCACertsBundle again, few gone, now total 59 certificates.
May 25, 2022 V8.69 Fixed memory leak, thanks to Yunga.
             Updated sslRootCACertsBundle, many gone, some new, now total 53 certificates.
Jul 06, 2023 V8.71 Allow creation of non-CA certificates with real names, only check
               for Puny names for server certificates, not client or email.
             Implemented Assign in TSslCertTools, thanks to uso.
             Updated sslRootCACertsBundle, few gone, some new, now total 54 certificates.
Aug 08, 2023 V9.0  Updated version to major release 9.
Jan 22, 2024 V9.1  Added OverbyteIcsSslBase which now includes TX509Base and TX509List.
                   Moved sslRootCACertsBundle function to OverbyteIcsSslBase.
                   Added CaCertLines property which returns CA PEM lines, used to create
                     bundle with intermediate.
                   When creating certificates, if BasicPathLen=-1 leave out Basic
                     Constraints pathlen so root certificates can sign intermediates.
                   Function CreateSelfSignCertEx has an extra argument for the file name
                     of a root CA signing bundle, usually an intermediate bundle, that
                     is used to create a CA signed certificate instead of self signed.
                     Password for CA must be same as certificate.  Designed for use
                     with GSSL_INTER_FILE which defaults to an ICS signed intermediate
                     allowing servers to issue their own certificates.
Aug 07, 2024 V9.3  Moved many types and constants to OverbyteIcsTypes for consolidation.
                   CreateSelfSignCertEx works on Posix.
                   Removed OverbyteIcsWSocket, IPv4/6 conversions now in Utils.
Oct 25, 2024 V9.4 Using OpenSSL 3.0 names for some EVP_PKEY functions, adding get.
                  Updated Base64 encoding functions to IcsBase64 functions.
                  When creatinng X509 certificate request, set version 1 not 3,
                    fails with OpenSSL 3.4 which seems to validate it.
Sep 03, 2025 V9.5 RSA en/decryption only works for DEFINE OpenSSL_Deprecated, pending
                    rewrite with EVP_ functions.  Fixed a problem that meant an
                    exception was raised due to a blank RSA key.  Pending rewrite
                    using modern APIs, sample is now OverbyteIcsJoseTst not PemTools.
                  TSslCertTools.DoDHParams no longer works without DEFINE
                    OpenSSL_Deprecated, not needed for modern cyphers.
                  CreateSelfSignCertEx now adds IP addresses to the correct
                    alternate list, not allowed as common name.
                  Added certificate properties for more Distinguished Names, mainly for
                    personal names: Street, SurName, GivenName, NameTitle, NameInitials.
                    Description no longer gives an error.



Pending - long term
Create string and file encryption component from existing functions

OpenSSL 3.0 deprecates RSA_public_encrypt, RSA_private_decrypt, need to be replaced
by EVP_PKEY_encrypt_init_ex, EVP_PKEY_encrypt, EVP_PKEY_decrypt_init_ex and EVP_PKEY_decrypt.



Using TSslCertTools component
=============================

The main test application for the component is the OverbyteIcsPemtool sample,
which illustrates use of all the methods and properties.

Message digests or hashes:
    TEvpDigest = (Digest_md5, Digest_mdc2, Digest_sha1, Digest_sha224,
        Digest_sha256, Digest_sha384, Digest_sha512, Digest_ripemd160);

Private key algorithm and key length in bits, bracketed comment is security
level and effective bits, beware long RSA key lengths increase SSL overhead heavily:
    TSslPrivKeyType = (
        PrivKeyRsa1024,   // level 1 - 80 bits
        PrivKeyRsa2048,   // level 2 - 112 bits
        PrivKeyRsa3072,   // level 3 - 128 bits
        PrivKeyRsa4096,   // level 3 - 148 bits?
        PrivKeyRsa7680,   // level 4 - 192 bits
        PrivKeyRsa15360,  // level 5 - 256 bits
        PrivKeyECsecp256, // level 3 - 128 bits
        PrivKeyECsecp384, // level 4 - 192 bits
        PrivKeyECsecp512, // level 5 - 256 bits
        PrivKeyECX25519); // level 3 - 128 bits

Private key file encryption:
   TSslPrivKeyCipher = (
        PrivKeyEncNone, PrivKeyEncAES128, PrivKeyEncAES192, PrivKeyEncAES256);


Create a new private key file
-----------------------------
A private key is required to create a self signed certificate or a certificate
request, and needs to be installed on any SSL servers (never distribute it).
1 - Set property PrivKeyType (RSA or EC) from TSslPrivKeyType.
2 - Create keys using DoKeyPair method checking exception for any errors.
3 - PrivateKey property contains pointer to new private key.
4 - If file to be encrypted, set property PrivKeyCipher from TSslPrivKeyCipher.
5 - Save private key to file using PrivateKeySaveToPemFile method with optional password.
6 - Optionally save public key to file using PublicKeySaveToPemFile method.

Create a new certificate request from properties
------------------------------------------------
A certificate request is needed to buy a commercial SSL certificate from a public
certificate authority and most importantly specifies the host domain name of the
public SSL server it will secure.
1 - Create a new private key (see above) or load an old key using
PrivateKeyLoadFromPemFile or PrivateKeyLoadFromText methods.
2 - Specify request properties, CommonName (host domain name), Country, State,
Locality, Organization, OrgUnit, KeyDigiSign, KeyKeyEnc, etc, as needed.
3 - Create request using DoCertReqProps method checking exception for any errors.
4 - X509Req property contains pointer to new request.
5 - Save request to PEM file using SaveReqToFile method.
6 - Optionally save request to string using SaveReqToText method.

Create a new certificate request from old certificate
-----------------------------------------------------
This is a shorter way to create a new request when renewing an existing
certificate with the same private key.
1 - Load existing certificate using LoadFromFile or LoadFromText methods.
2 - Load private key for existing certificate using PrivateKeyLoadFromPemFile or
PrivateKeyLoadFromText methods.
3 - Create request using DoCertReqOld method checking exception for any errors.
4 - X509Req property contains pointer to new request.
5 - Save request to PEM file using SaveReqToFile method.
6 - Optionally save request to string using SaveReqToText method.

Create new self signed certificate from properties
--------------------------------------------------
Self signed certificates are mostly used for testing SSL applications on
temporary servers, prior to final deployment to a public server with a
commercial SSL certificate.  Can also used for internal networks.   May
also be used to create your own CA certificate if you want to sign your
own certificates.
1 - Create a new private key (see above) or load an old key using
PrivateKeyLoadFromPemFile or PrivateKeyLoadFromText methods.
2 - Specify certificate properties, CommonName (host domain name), Country, State,
Locality, Organization, OrgUnit, KeyDigiSign, KeyKeyEnc, etc, as needed.
3 - Select CertDigest (hash) property from TEvpDigest.
4 - Create certificate using DoSelfSignCert method checking exception for any errors.
5 - X509 property contains pointer to new certificate.
6 - If file to be encrypted, set property PrivKeyCipher from TSslPrivKeyCipher.
7 - Save certificate to file using SaveToFile method with the file extension
specifying the format that should be used.  Options include IncludePrivateKey
which will save the private key into the same PEM or P12 file, and optional password.
8 - Optionally save certificate to string using SaveCertToText method.

Create new CA signed certificate from certificate request
---------------------------------------------------------
This is how commercial certificate authorities create SSL certificates from
a request, signing it with their own CA certificate (root or intermediate) that
will be trusted by Windows due to the root already being installed locally.
For development, you can create your own CA root certificate and install it in
the Windows certificate store of any test computers, then create certificates
signed by the root and they will be trusted by Windows without needing to accept
security exceptions as happens with self signed certificates.
1 - The CA certificate and CA private key need to loaded using LoadFromFile and
PrivateKeyLoadFromPemFile into X509 and PrivateKey, and these properties
assigned to X509CA and PrivKeyCA respectively.
2 - Load certificate request using LoadReqFromFile.
3 - Currently the subject certificate properties are taken from the request and
can not be edited, extended properties are currently taken from properties,
KeyDigiSign, KeyKeyEnc, etc, as needed.  This needs more work for flexibility.
4 - Select CertDigest (hash) property from TEvpDigest.
5 - Create certificate using DoSignCertReq method checking exception for any errors.
6 - X509 property contains pointer to new certificate.
7 - If file to be encrypted, set property PrivKeyCipher from TSslPrivKeyCipher.
8 - Save certificate to file using SaveToFile method with the file extension
specifying the format that should be used.  Options include IncludePrivateKey
which will save the private key into the same PEM or P12 file, and optional password.
9 - Optionally save certificate to string using SaveCertToText method.

Beware the private key used to create the request must be loaded into PrivateKey
property before saving a private key with the certificate, otherwise the CA key
may be incorrectly saved.

Pending - save details of certificates created to database, to support
transparency and certificate revocation lists.  Currently certificates have
random serial numbers, should allow sequential numbers to be allocated.

Convert certificate from one file format to another
---------------------------------------------------
1 - Load existing certificate using LoadFromFile or LoadFromText methods.
2 - Optionally load private key for existing certificate using
PrivateKeyLoadFromPemFile or PrivateKeyLoadFromText methods.
4 - If file to be encrypted, set property PrivKeyCipher from TSslPrivKeyCipher.
4 - Save certificate to file using SaveToFile method with the file extension
specifying the format that should be used.  Options include IncludePrivateKey
which will save the private key into the same PEM or P12 file, and optional password.
One use for this is to convert base64 DER/PEM certificates into P12/PVX format
that can be easily installed into the Windows certificate store.

Create New DHParams File
------------------------
DHParams contain prime numbers needed to support DH and DHE ciphers (but not
ECDH and ECDHE).  Ideally they should be unique per server and/or application
and some applications even generate new params each day.  But finding prime
numbers is time consuming, the shortest 1,024 bits can take up a minute, 2,048
bits several minutes, 4,096 bits a few hours, and gave up with 8,192 bits after
two days.  ICS include constants sslDHParams2048 and sslDHParams4096 to save
you calculating your own.
1 - Assign OnKeyProgress event handler with Application.ProcessMessages and
optionally a progress indicator so the application remains responsive while
calculating DHParams.
2 - Create DHParams using DoDHParams method passing new file name and number of
bits, 768, 1024, 20248, 4096, 8192.
3 - Optionally save DHParams string returned by DoDHParams method.

Create Certificate Bundle
-------------------------
Builds a new PEM or PKCS12 file by combining certificate, private key and
intermediate files (in any formats with correct file extension).  For servers,
a bundle file is easier to distribute and load than three separate files.
1 - CreateCertBundle is a simple function, that requires four full file names
for the three input files and output file, optional load and save passwords,
and the cipher optionally to encrypt the output file.


 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFNDEF ICS_INCLUDE_MODE}
unit OverbyteIcsSslX509Utils;
{$ENDIF}

{$I include\OverbyteIcsDefs.inc}
{.I Include\OverbyteIcsSslDefs.inc gone V9.1 }
{$IFDEF COMPILER14_UP}
  {$IFDEF NO_EXTENDED_RTTI}
    {$RTTI EXPLICIT METHODS([]) FIELDS([]) PROPERTIES([])}
  {$ENDIF}
{$ENDIF}
{$IFDEF COMPILER12_UP}
    { These are usefull for debugging !}
    {$WARN IMPLICIT_STRING_CAST       ON}
    {$WARN IMPLICIT_STRING_CAST_LOSS  ON}
    {$WARN EXPLICIT_STRING_CAST       OFF}
    {$WARN EXPLICIT_STRING_CAST_LOSS  OFF}
{$ENDIF}
{$WARN SYMBOL_PLATFORM   OFF}
{$WARN SYMBOL_LIBRARY    OFF}
{$WARN SYMBOL_DEPRECATED OFF}
{$IFDEF BCB}
    {$ObjExportAll On}
{$ENDIF}

interface

{$IFDEF USE_SSL}

uses

{$IFDEF MSWINDOWS}
  {$IFDEF RTL_NAMESPACES}Winapi.Windows{$ELSE}Windows{$ENDIF},
{$ENDIF}
  {$IFDEF RTL_NAMESPACES}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  {$IFDEF RTL_NAMESPACES}System.Classes{$ELSE}Classes{$ENDIF},
    OverbyteIcsSSLEAY, OverbyteIcsLibeay,
{$IFDEF FMX}
//    Ics.Fmx.OverbyteIcsWSocket,
    Ics.Fmx.OverbyteIcsSslBase,  { V9.1 TX509Base }
{$ELSE}
//    OverbyteIcsWSocket,
    OverbyteIcsSslBase,    { V9.1 TX509Base }
{$ENDIF FMX}
    OverByteIcsMD5,
    OverbyteIcsTypes,
    OverbyteIcsLogger,
    OverbyteIcsMimeUtils,
    OverbyteIcsUtils
 {$IFDEF YuOpenSSL}, YuOpenSSL{$ENDIF YuOpenSSL};

const
    BF_BLOCK_SIZE     = 8;

type
    TCryptProgress = procedure(Obj: TObject; Count: Int64; var Cancel: Boolean);

    PMD5Digest = ^TMD5Digest;
    TCipherType = (ctBfCbc, ctBfCfb64, ctBfOfb, ctBfEcb);

    TIVector = array[0..8] of Byte;
    PIVector = ^TIVector;

    TCipherKey = array[0..47] of Byte;
    TCipherKeyLen = (cklDefault, ckl64bit, ckl128bit, ckl256bit);
    PCipherKey = ^TCipherKey;

    TCipherSalt = String[PKCS5_SALT_LEN];//array[0..PKCS5_SALT_LEN -1] of Byte;

    TCiphContext = packed record
        Key       : TCipherKey;
        IV        : TIVector;
          //IVLen     : Integer;
        Ctx       : PEVP_CIPHER_CTX;
        Cipher    : PEVP_CIPHER;
        Encrypt   : Boolean;
        BlockSize : Integer;
    end;
    PCiphContext = ^TCiphContext;

    TAltItem = record      { V8.64 }
        AltName:  AnsiString;
        AltType:  Integer;
        PunyFlag: Boolean;
    end;

type
    ECertToolsException = class(Exception);

  { V8.40 component to create SSL certificates and keys }
    TSslCertTools = class(TX509Base)
    private
        FNewCert           : PX509;
        FNewReq            : PX509_REQ;
        FRsaKey            : PRSA;
        FPrivKey           : PEVP_PKEY;
        FECkey             : PEC_KEY;
        FECgroup           : PEC_GROUP;
        FX509Req           : Pointer;
        FX509CA            : Pointer;
        FPrivKeyCA         : PEVP_PKEY;
        FCountry           : String;
        FState             : String;
        FLocality          : String;
        FOrganization      : String;
        FOrgUnit           : String;
        FDescr             : String;
        FEmail             : String;
        FCommonName        : String;
        FStreet            : String;    { V9.5 }
        FSurName           : String;    { V9.5 }
        FGivenName         : String;    { V9.5 }
        FNameTitle         : String;    { V9.5 }
        FNameInitials      : String;    { V9.5 }
        FAltDNSList        : TStrings;
        FAltIpList         : TStrings;
        FAltEmailList      : TStrings;
        FAltIssuer         : String;
        FCRLDistPoint      : String;  // URI:http://myhost.com/myca.crl
        FAuthInfoAcc       : String;  // OCSP;URI:http://ocsp.myhost.com/
        FBasicIsCA         : Boolean;
        FBasicPathLen      : Integer;
        FKeyCertSign       : Boolean;
        FKeyCRLSign        : Boolean;
        FKeyDigiSign       : Boolean;
        FKeyDataEnc        : Boolean;
        FKeyKeyEnc         : Boolean;
        FKeyKeyAgree       : Boolean;
        FKeyNonRepud       : Boolean;
        FKeyExtClient      : Boolean;
        FKeyExtServer      : Boolean;
        FKeyExtEmail       : Boolean;
        FKeyExtCode        : Boolean;
        FExpireDays        : Integer;
        FSerialNum         : Int64;
        FAddComments       : boolean;
        FPrivKeyType       : TSslPrivKeyType;
        FPrivKeyCipher     : TSslPrivKeyCipher;
        FCertDigest        : TEvpDigest;
        FOnKeyProgress     : TNotifyEvent;
        FAltAnsiStr        : array of AnsiString;
        FAltIa5Str         : array of PASN1_STRING;
        FAltGenStr         : array of PGENERAL_NAME;
        FCADBFile          : String;   { V8.57 }
        FAcmeIdentifier    : String;   { V8.62 }
        FAltItems          : array of TAltItem;  { V8.64 }
        FTotAltItems       : Integer;            { V8.64 }
    protected
        function    BuildBasicCons(IsCA: Boolean): AnsiString;
        function    BuildKeyUsage: AnsiString;
        function    BuildExKeyUsage: AnsiString;
        procedure   SetCertExt(Cert: PX509; Nid: integer; const List: AnsiString);
        procedure   BuildAltPropList;                      { V8.64 }
        procedure   BuildAltReqList;                       { V8.64 }
        function    BuildAltStackAll: PStack;              { V8.64 }
        procedure   BuildCertAltSubjAll(Cert: PX509);      { V8.64 }
        procedure   ClearAltStack;
        procedure   FreeAndNilX509CA;
        procedure   FreeAndNilPrivKeyCA;
        procedure   FreeAndNilX509Req;
        procedure   SetX509Req(X509Req: Pointer);
        procedure   SetX509CA(Cert: Pointer);
        procedure   SetPrivKeyCA(Pkey: PEVP_PKEY);
        function    GetReqSubjOneLine: String;
        function    GetReqSubjCName: String;
        function    GetReqSubjOName: String;
        function    GetReqSubjAltNameDNS: String;
        function    GetReqSubjAltNameIP: String;
        function    GetReqKeyUsage: String;
        function    GetReqExKeyUsage: String;
        function    GetReqCertInfo: String;
        function    GetIsReqLoaded: Boolean;
        function    GetIsCALoaded: Boolean;
        procedure   WriteReqToBio(ABio: PBIO; AddInfoText: Boolean = FALSE; const FName: String = ''); virtual;
        function    GetReqKeyInfo: string;       { V8.52 }
        function    GetReqSignAlgo: String;      { V8.52 }
        function    GetCaCertLines: String;      { V9.1 }
    public
        constructor Create(AOwner: TComponent);
        destructor  Destroy; override;
        procedure   Assign(Source: TPersistent); override;  { V8.71 }
        procedure   DoCertReqProps;
        procedure   DoCertReqOld;
        procedure   DoSelfSignCert(UseCSR: Boolean = False);   { V8.57 added UseCSR }
        procedure   DoSignCertReq(CopyExtns: Boolean);
        procedure   DoKeyPair;
//        procedure   DoKeyPairOld;
        function    DoDHParams(const FileName: String; Bits: integer): String;
        procedure   DoClearCerts;
        procedure   DoClearCA;  { V8.57 split from DoClearCerts }
        function    SaveToCADatabase(const CertFName: String = 'unknown'): Boolean;  { V8.57 }
        procedure   CreateCertBundle(const CertFile, PKeyFile, InterFile, LoadPw,
                      SaveFile, SavePw: String; KeyCipher: TSslPrivKeyCipher = PrivKeyEncNone);
        function    GetReqEntryByNid(ANid: Integer): String;
        function    GetRequestRawText: String;
        procedure   LoadReqFromFile(const FileName: String);
        procedure   SaveReqToFile(const FileName: String; AddInfoText: Boolean = FALSE);
        function    SaveReqToText(AddInfoText: Boolean = FALSE): String;
        function    SaveReqToDERText: AnsiString;                             { V8.52, V8.64 was SaveToDERText }
        function    SaveCertToDERText: AnsiString;                            { V8.64 }
        function    GetKeyParams(var Params: POSSL_PARAM): Boolean;           { V8.67 }
        function    GetReqExtValuesByName(const ShortName, FieldName: String): String;
        function    GetReqExtByName(const S: String): TExtension;
        property    X509Req             : Pointer       read FX509Req       write SetX509Req;
        property    X509CA              : Pointer       read FX509CA        write SetX509CA;
        property    PrivKeyCA           : PEVP_PKEY     read FPrivKeyCA     write SetPrivKeyCA;
        property    ReqSubjOneLine      : String        read GetReqSubjOneLine;
        property    ReqSubjCName        : String        read GetReqSubjCName;
        property    ReqSubjOName        : String        read GetReqSubjOName;
        property    ReqSubjAltNameDNS   : String        read GetReqSubjAltNameDNS;
        property    ReqSubjAltNameIP    : String        read GetReqSubjAltNameIP;
        property    ReqKeyUsage         : String        read GetReqKeyUsage;
        property    ReqExKeyUsage       : String        read GetReqExKeyUsage;
        property    ReqCertInfo         : String        read GetReqCertInfo;
        property    IsReqLoaded         : Boolean       read GetIsReqLoaded;
        property    IsCALoaded          : Boolean       read GetIsCALoaded;
        property    ReqKeyInfo          : String        read GetReqKeyInfo;       { V8.52 }
        property    ReqSignAlgo         : String        read GetReqSignAlgo;      { V8.52 }
        property    CaCertLines         : String        read GetCaCertLines;      { V9.1 }
    published
        property Country           : String             read FCountry       write FCountry;
        property State             : String             read FState         write FState;
        property Locality          : String             read FLocality      write FLocality;
        property Organization      : String             read FOrganization  write FOrganization;
        property OrgUnit           : String             read FOrgUnit       write FOrgUnit;
        property Descr             : String             read FDescr         write FDescr;
        property Email             : String             read FEmail         write FEmail;
        property CommonName        : String             read FCommonName    write FCommonName;
        property Street            : String             read FStreet        write FStreet;       { V9.5 }
        property SurName           : String             read FSurName       write FSurName;      { V9.5 }
        property GivenName         : String             read FGivenName     write FGivenName;    { V9.5 }
        property NameTitle         : String             read FNameTitle     write FNameTitle;    { V9.5 }
        property NameInitials      : String             read FNameInitials  write FNameInitials; { V9.5 }
        property AltDNSList        : TStrings           read FAltDNSList    write FAltDNSList;
        property AltIpList         : TStrings           read FAltIpList     write FAltIpList;
        property AltEmailList      : TStrings           read FAltEmailList  write FAltEmailList;
        property AltIssuer         : String             read FAltIssuer     write FAltIssuer;
        property CRLDistPoint      : String             read FCRLDistPoint  write FCRLDistPoint;
        property AuthInfoAcc       : String             read FAuthInfoAcc   write FAuthInfoAcc;
        property AcmeIdentifier    : String             read FAcmeIdentifier write FAcmeIdentifier; { V8.62 }
        property BasicIsCA         : Boolean            read FBasicIsCA     write FBasicIsCA;
        property BasicPathLen      : Integer            read FBasicPathLen  write FBasicPathLen;
        property KeyCertSign       : Boolean            read FKeyCertSign   write FKeyCertSign;
        property KeyCRLSign        : Boolean            read FKeyCRLSign    write FKeyCRLSign;
        property KeyDigiSign       : Boolean            read FKeyDigiSign   write FKeyDigiSign;
        property KeyDataEnc        : Boolean            read FKeyDataEnc    write FKeyDataEnc;
        property KeyKeyEnc         : Boolean            read FKeyKeyEnc     write FKeyKeyEnc;
        property KeyKeyAgree       : Boolean            read FKeyKeyAgree   write FKeyKeyAgree;
        property KeyNonRepud       : Boolean            read FKeyNonRepud   write FKeyNonRepud;
        property KeyExtClient      : Boolean            read FKeyExtClient  write FKeyExtClient;
        property KeyExtServer      : Boolean            read FKeyExtServer  write FKeyExtServer;
        property KeyExtEmail       : Boolean            read FKeyExtEmail   write FKeyExtEmail;
        property KeyExtCode        : Boolean            read FKeyExtCode    write FKeyExtCode;
        property ExpireDays        : Integer            read FExpireDays    write FExpireDays;
        property SerialNum         : Int64              read FSerialNum     write FSerialNum;
        property AddComments       : boolean            read FAddComments   write FAddComments;
        property PrivKeyType       : TSslPrivKeyType    read FPrivKeyType   write FPrivKeyType;
        property PrivKeyCipher     : TSslPrivKeyCipher  read FPrivKeyCipher write FPrivKeyCipher;
        property CertDigest        : TEvpDigest         read FCertDigest    write FCertDigest;
        property CADBFile          : String             read FCADBFile      write FCADBFile;    { V8.57 }
        property OnKeyProgress     : TNotifyEvent       read FOnKeyProgress write FOnKeyProgress;
    end;



procedure CreateCertRequest(const RequestFileName, KeyFileName, Country, State, Locality, Organization, OUnit,
                                              CName, Email: String; Bits: Integer; Comment: boolean = false); {overload; }

procedure CreateSelfSignedCert(const FileName, Country, State, Locality, Organization, OUnit, CName, Email: String;
    Bits: Integer; IsCA: Boolean; Days: Integer; const KeyFileName: String = ''; Comment: boolean = false);  { overload; }

  procedure CreateSelfSignCertEx(const FileName, CName: String; AltDNSLst: TStrings; PKeyType: TSslPrivKeyType =
           PrivKeyECsecp256; const PW: String = '';  const AcmeId: String = ''; const InterCAFile: String = '');  { V8.64, V9.1 InterCA }


{ RSA crypto functions }

{$IFDEF OpenSSL_Deprecated}  { V9.5 }
procedure CreateRsaKeyPair(const PubFName, PrivFName: String; Bits: Integer);  { V8.35 }
{$ENDIF OpenSSL_Deprecated}   { V9.5 }

{$IFDEF OpenSSL_Deprecated}  { V9.5 }
type
  TRsaPadding = (rpPkcs1, rpPkcs1Oaep, rpNoPadding);
  { rpPkcs1 - This currently is the most widely used mode             }
  { rpPkcs1Oaep - This mode is recommended for all new applications   }
  { rpNoPadding - Don't use                                           }
  { http://www.openssl.org/docs/crypto/RSA_public_encrypt.html        }

  function DecryptPrivateRSA(
      PrivKey     : PEVP_PKEY;
      InBuf       : Pointer;
      InLen       : Cardinal;
      OutBuf      : Pointer;
      var OutLen  : Cardinal;
      Padding     : TRsaPadding): Boolean;

  function EncryptPublicRSA(
      PubKey      : PEVP_PKEY;
      InBuf       : Pointer;
      InLen       : Cardinal;
      OutBuf      : Pointer;
      var OutLen  : Cardinal;
      Padding     : TRsaPadding): Boolean;

function StrEncRsa(PubKey: PEVP_PKEY; const S: AnsiString; B64: Boolean;
    Padding: TRsaPadding = rpPkcs1): AnsiString;
function StrDecRsa(PrivKey: PEVP_PKEY; S: AnsiString; B64: Boolean;
    Padding: TRsaPadding = rpPkcs1): AnsiString;
{$ENDIF OpenSSL_Deprecated}   { V9.5 }

{ Symmetric cipher stuff, far from being completed.       }
{ Should probably be implemented as a class or component. }


procedure CiphPasswordToKey(InBuf: AnsiString; Salt: TCipherSalt; Count: Integer;
    var Key: TCipherKey; var KeyLen: Integer; var IV: TIVector; var IVLen: Integer);
procedure CiphInitialize(var CiphCtx: TCiphContext; const Pwd: AnsiString; Key: PCipherKey;
    IVector: PIVector; CipherType: TCipherType; KeyLen: TCipherKeyLen; Enc: Boolean);
procedure CiphSetIVector(var CiphCtx: TCiphContext; IVector: PIVector);
procedure CiphFinalize(var CiphCtx: TCiphContext);
procedure CiphUpdate(const InBuf; InLen: Integer; const OutBuf;
    var OutLen: Integer; CiphCtx: TCiphContext);
procedure CiphFinal(const OutBuf; var OutLen : Integer; CiphCtx : TCiphContext);

function StrEncBf(const S: AnsiString; const Pwd: AnsiString; IV: PIVector;
    KeyLen: TCipherKeyLen; B64: Boolean): AnsiString;
function StrDecBf(S: AnsiString; const Pwd: AnsiString; IV: PIVector;
    KeyLen: TCipherKeyLen; B64: Boolean): AnsiString;

procedure StreamEncrypt(SrcStream: TStream; DestStream: TStream;
    StrBlkSize: Integer; CiphCtx: TCiphContext; RandomIV: Boolean); overload;
procedure StreamDecrypt(SrcStream: TStream; DestStream: TStream;
    StrBlkSize: Integer; CiphCtx: TCiphContext; RandomIV: Boolean); overload;
procedure StreamEncrypt(SrcStream: TStream; DestStream: TStream;
    StrBlkSize: Integer; CiphCtx: TCiphContext; RandomIV: Boolean;
    Obj: TObject; ProgressCallback : TCryptProgress); overload;
procedure StreamDecrypt(SrcStream: TStream; DestStream: TStream;
    StrBlkSize: Integer; CiphCtx: TCiphContext; RandomIV: Boolean;
    Obj: TObject; ProgressCallback : TCryptProgress); overload;

// function sslRootCACertsBundle: TBytes;      { V9.1 moved to SslBase }



{$ENDIF}  { USE_SSL }

implementation

{$IFDEF USE_SSL}


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure RaiseLastOpenSslError(EClass: ExceptClass; Dump: Boolean = FALSE; const CustomMsg: AnsiString = '');
const
    CRLF = AnsiString(#13#10);
begin
    if Length(CustomMsg) > 0 then
        raise EClass.Create(String(CRLF + CustomMsg + CRLF +
                            LastOpenSslErrMsg(Dump) + CRLF))
    else
        raise EClass.Create(String(CRLF + LastOpenSslErrMsg(Dump) + CRLF));
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure AddNameEntryByTxt(Name: PX509_NAME; const Field: AnsiString; const Value: String);
var
    AStr : AnsiString;
    SType: Cardinal;
begin
    if IsUsAscii(Value) then begin
        AStr  := AnsiString(Value);
        SType := MBSTRING_ASC;
    end
    else begin
        AStr  := StringToUtf8(Value);
        { If we used MBSTRING_UTF8 the string would be converted to Ansi }
        { with current code page by OpenSSL silently, strange.           }
        SType := V_ASN1_UTF8STRING;
    end;
    if Length(AStr) = 0 then
        exit;
    if X509_NAME_add_entry_by_txt(Name, PAnsiChar(Field),  SType, PAnsiChar(AStr), -1, -1, 0) = 0 then
         RaiseLastOpenSslError(ECertToolsException, FALSE, 'Can not add distinguished name entry "' + Field + '"');   { V9.5 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure AddNameEntryByNid(Name: PX509_NAME; Nid: Integer; const Value: String);  { V9.5 }
var
    AStr : AnsiString;
    SType: Cardinal;
begin
    if IsUsAscii(Value) then begin
        AStr  := AnsiString(Value);
        SType := MBSTRING_ASC;
    end
    else begin
        AStr  := StringToUtf8(Value);
        { If we used MBSTRING_UTF8 the string would be converted to Ansi }
        { with current code page by OpenSSL silently, strange.           }
        SType := V_ASN1_UTF8STRING;
    end;
    if Length(AStr) = 0 then
        exit;
    if X509_NAME_add_entry_by_nid(Name, Nid,  SType, PAnsiChar(AStr), -1, -1, 0) = 0 then
         RaiseLastOpenSslError(ECertToolsException, FALSE, 'Can not add distinguished name NID "' + AnsiString(IntToStr(Nid)) + '"');
end;


{ V8.40 component to create SSL certificates and keys }
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
Constructor TSslCertTools.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    FPrivKeyType := PrivKeyRsa2048;
    FPrivKeyCipher := PrivKeyEncNone;
    FCertDigest := Digest_sha256;
    FBasicPathLen := 0;
    FNewCert := Nil;
    FNewReq := Nil;
    FRsaKey := Nil;
    FPrivKey := Nil;
    FECkey := Nil;
    FECgroup := Nil;
    FX509Req := nil;
    FX509CA := Nil;
    FPrivKeyCA := Nil;
    FAltDNSList  := TStringList.Create;
    FAltIpList := TStringList.Create;
    FAltEmailList := TStringList.Create;
    SetLength (FAltAnsiStr, 0);
    SetLength (FAltGenStr, 0);
    SetLength (FAltIa5Str, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
destructor TSslCertTools.Destroy;
begin
    FAltDNSList.Free;      { V8.69 even if no SSL }
    FAltIpList.Free;
    FAltEmailList.Free;
    if FSslInitialized then begin
     // must free public pointers before those they point to
        ClearAll;   { V8.65 }
        if Assigned(FNewCert) then
            X509_free(FNewCert);
        if Assigned(FNewReq) then
            X509_REQ_free(FNewReq);
        if Assigned(FPrivKey) then
            EVP_PKEY_free(FPrivKey);
         FreeAndNilX509Req;
         FreeAndNilX509CA;
         FreeAndNilPrivKeyCA;
    end;
    inherited Destroy;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslCertTools.Assign(Source: TPersistent);           { V8.71 }
var
    LSource: TSslCertTools;
begin
    if Source is TSslCertTools then begin
        LSource := Source as TSslCertTools;
        FCountry         := LSource.Country;
        FState           := LSource.State;
        FLocality        := LSource.Locality;
        FOrganization    := LSource.Organization;
        FOrgUnit         := LSource.OrgUnit;
        FDescr           := LSource.Descr;
        FEmail           := LSource.Email;
        FCommonName      := LSource.CommonName;
        FStreet          := LSource.Street;       { V9.5 }
        FGivenName       := LSource.GivenName;    { V9.5 }
        FSurName         := LSource.SurName;      { V9.5 }
        FNameTitle       := LSource.NameTitle;    { V9.5 }
        FNameInitials    := LSource.NameInitials; { V9.5 }
        FAltIpList.Assign(LSource.AltIpList);
        FAltDNSList.Assign(LSource.AltDNSList);
        FAltEmailList.Assign(LSource.AltEmailList);
        FAltIssuer       := LSource.AltIssuer;
        FCRLDistPoint    := LSource.CRLDistPoint;
        FAuthInfoAcc     := LSource.AuthInfoAcc;
        FAcmeIdentifier  := LSource.AcmeIdentifier;
        FBasicIsCA       := LSource.BasicIsCA;
        FBasicPathLen    := LSource.BasicPathLen;
        FKeyCertSign     := LSource.KeyCertSign;
        FKeyCRLSign      := LSource.KeyCRLSign;
        FKeyDigiSign     := LSource.KeyDigiSign;
        FKeyDataEnc      := LSource.KeyDataEnc;
        FKeyKeyEnc       := LSource.KeyKeyEnc;
        FKeyKeyAgree     := LSource.KeyKeyAgree;
        FKeyNonRepud     := LSource.KeyNonRepud;
        FKeyExtClient    := LSource.KeyExtClient;
        FKeyExtServer    := LSource.KeyExtServer;
        FKeyExtEmail     := LSource.KeyExtEmail;
        FKeyExtCode      := LSource.KeyExtCode;
        FExpireDays      := LSource.ExpireDays;
        FSerialNum       := LSource.SerialNum;
        FAddComments     := LSource.AddComments;
        FPrivKeyType     := LSource.PrivKeyType;
        FPrivKeyCipher   := LSource.PrivKeyCipher;
        FCertDigest      := LSource.CertDigest;
        FCADBFile        := LSource.CADBFile;
        FOnKeyProgress   := LSource.OnKeyProgress;
    end;
    inherited Assign(Source);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslCertTools.FreeAndNilX509Req;
begin
    if Assigned(FX509Req) then begin
        X509_REQ_free(FX509Req);
        FX509Req := nil;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslCertTools.FreeAndNilX509CA;
begin
    if NOT FSslInitialized then Exit;
    if Assigned(FX509CA) then begin
        X509_free(FX509CA);
        FX509CA := nil;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslCertTools.FreeAndNilPrivKeyCA;
begin
    if NOT FSslInitialized then Exit;
    if Assigned(FPrivKeyCA) then begin
        EVP_PKEY_free(FPrivKeyCA);
        FPrivKeyCA := nil;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslCertTools.SetX509CA(Cert: Pointer);
begin
    InitializeSsl;
    FreeAndNilX509CA;
    if Assigned(Cert) then begin
        FX509CA := X509_dup(Cert);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetIsReqLoaded: Boolean;
begin
    Result := Assigned(FX509Req);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetIsCALoaded: Boolean;
begin
    Result := Assigned(FX509CA);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslCertTools.SetPrivKeyCA(Pkey: PEVP_PKEY);
begin
    InitializeSsl;
    FreeAndNilPrivKeyCA;
    if Assigned(PKey) then begin
        FPrivKeyCA := Ics_EVP_PKEY_dup(PKey);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V9.1 returns CA PEM lines, used to create bundle with intermediate }
function TSslCertTools.GetCaCertLines: String;
var
    ABio : PBIO;
begin
    Result := '';
    if FX509CA = nil then Exit;
    ABio := BIO_new(BIO_s_mem);
    if Assigned(ABio) then
    try
        if PEM_write_bio_X509(ABio, FX509CA) = 0 then
            RaiseLastOpenSslError(EX509Exception, TRUE, 'Error writing CA certificate');
        Result := String(IcsReadStrBio(ABio, 9999));
    finally
        bio_free(ABio);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslCertTools.SetX509Req(X509Req: Pointer);
begin
    InitializeSsl;
    FreeAndNilX509Req;
    if Assigned(X509Req) then begin
        FX509Req := X509_REQ_dup(X509Req);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ returns formatted text with raw certificate request fields }
function TSslCertTools.GetRequestRawText: String;
var
    ABio  : PBIO;
begin
    Result := '';
    if FX509Req = nil then Exit;
    ABio := BIO_new(BIO_s_mem);
    if Assigned(ABio) then
    try
        X509_REQ_print(ABio, FX509Req);
        Result := String(IcsReadStrBio(ABio, 9999));    { V9.1 simplify }
    finally
        bio_free(ABio);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ PKCS#10 certificate request, typical file extension .PEM, .DER }
procedure TSslCertTools.LoadReqFromFile(const FileName: String);
var
    FileBio : PBIO;
    Req : PX509_REQ;
begin
    InitializeSsl;
    FileBio := IcsSslOpenFileBio(FileName, bomReadOnly);
    try
        Req := PEM_read_bio_X509_REQ(FileBio, Nil, Nil, Nil);  { base64 version }
        if NOT Assigned (Req) then begin
            BIO_ctrl(FileBio, BIO_CTRL_RESET, 0, nil);
            Req := d2i_X509_REQ_bio(FileBio, Nil);            { DER binary version }
        end;
        if NOT Assigned (Req) then
            RaiseLastOpenSslError(EX509Exception, TRUE, 'Error reading certificate request from file');
        SetX509Req(Req);
        X509_REQ_free(Req);
    finally
        bio_free(FileBio);
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ write PKCS10 certificate request to BIO }
procedure TSslCertTools.WriteReqToBio(ABio: PBIO; AddInfoText: Boolean = FALSE; const FName: String = '');
var
    comments: AnsiString;
begin
    if not Assigned(ABio) then
        raise EX509Exception.Create('BIO not assigned');
    if not Assigned(FX509Req) then
        raise EX509Exception.Create('FX509Req not assigned');
    if AddInfoText then begin
        comments := StringToUtf8(GetReqCertInfo) + #13#10;   { V8.65 UTF8 not ANSI }
        if BIO_write(ABio, @comments [1], Length (comments)) = 0 then
            RaiseLastOpenSslError(EX509Exception, TRUE, 'Error writing raw text to ' + FName);
    end;
    if PEM_write_bio_X509_REQ(ABio, PX509_REQ(FX509Req)) = 0 then
        RaiseLastOpenSslError(EX509Exception, TRUE, 'Error writing request to BIO' + FName);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ save PKCS10 certificate request }
procedure TSslCertTools.SaveReqToFile(const FileName: String; AddInfoText: Boolean = FALSE);
var
    FileBio : PBIO;
begin
    if not Assigned(FX509Req) then
        raise EX509Exception.Create('Certificate request not assigned');
    FileBio := IcsSslOpenFileBio(FileName, bomWrite);
    try
        WriteReqToBio(FileBIO, AddInfoText);
    finally
        bio_free(FileBio);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ returns base64 encoded DER PEM certificate request }
function TSslCertTools.SaveReqToText(AddInfoText: Boolean = FALSE): String;
var
    ABio  : PBIO;
begin
    Result := '';
    if FX509Req = nil then Exit;
    ABio := BIO_new(BIO_s_mem);
    if Assigned(ABio) then
    try
        WriteReqToBio(ABio, AddInfoText);
        Result := String(IcsReadStrBio(ABio, 9999));    { V9.1 simplify }
    finally
        bio_free(ABio);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ returns binary DER certificate request }
function TSslCertTools.SaveReqToDERText: AnsiString;      { V8.52, V8.64 was SaveToDERText }
var
    ABio  : PBIO;
begin
    Result := '';
    if FX509Req = nil then Exit;
    ABio := BIO_new(BIO_s_mem);
    if Assigned(ABio) then
    try
        if i2d_X509_REQ_bio(ABio, PX509_REQ(FX509Req)) = 0 then
           RaiseLastOpenSslError(EX509Exception, TRUE, 'Error writing request to BIO');
        Result := IcsReadStrBio(ABio, 9999);    { V9.1 simplify }
    finally
        bio_free(ABio);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ returns binary DER certificate }
function TSslCertTools.SaveCertToDERText: AnsiString;                  { V8.64 }
var
    ABio  : PBIO;
begin
    Result := '';
    if not Assigned(X509) then Exit;
    ABio := BIO_new(BIO_s_mem);
    if Assigned(ABio) then
    try
        if i2d_X509_bio(ABio, X509) = 0 then
            RaiseLastOpenSslError(EX509Exception, TRUE, 'Error writing DER certificate to BIO');
        Result := IcsReadStrBio(ABio, 9999);    { V9.1 simplify }
    finally
        bio_free(ABio);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Returns a CRLF-separated list if multiple entries exist }
function TSslCertTools.GetReqEntryByNid(ANid: Integer): String;
var
    Name    : PX509_NAME;
begin
    Result := '';
    if not Assigned(X509Req) then
        Exit;
    Name := X509_REQ_get_subject_name(X509Req);   { V8.66 }
    if Name <> nil then
        Result := GetPX509NameByNid(Name, ANid);  { V8.41 }
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqSubjOneLine: String;
var
    Str : AnsiString;
begin
    Result := '';
    if not Assigned(FX509Req) then
        Exit;

    SetLength(Str, 512);
    Str := X509_NAME_oneline(X509_REQ_get_subject_name(FX509Req),
                                              PAnsiChar(Str), Length(Str));  { V8.66 }
    SetLength(Str, StrLen(PAnsiChar(Str)));
    Result := String(Str);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqSubjCName: String;
begin
    Result := GetReqEntryByNid(NID_commonName);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqSubjOName: String;
begin
    Result := GetReqEntryByNid(NID_organizationName);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqExtByName(const S: String): TExtension;
var
    ExtnStack : PStack;
    I         : Integer;
    Ext       : PX509_EXTENSION;
    Count     : Integer;
begin
    Result.Critical  := FALSE;
    Result.ShortName := '';
    Result.Value     := '';
    if NOT Assigned(FX509Req) then Exit;
    ExtnStack := X509_REQ_get_extensions(FX509Req);
    if NOT Assigned(ExtnStack) then Exit;
    Count := OPENSSL_sk_num(ExtnStack);
    for I := 0 to Count - 1 do begin
        Ext := PX509_EXTENSION(OPENSSL_sk_value(ExtnStack, I));
        if not Assigned(Ext) then
            Continue;
        if CheckExtName(Ext, S) then begin    { V8.41 simplify }
            Result := GetExtDetail(Ext);
            Exit;
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqExtValuesByName(const ShortName, FieldName: String): String;
var
    Ext    : TExtension;
begin
    Result := '';
    if not Assigned(X509Req) then
        Exit;
    Ext := GetReqExtByName(ShortName);
    if Length(Ext.ShortName) > 0 then begin
        Result := GetExtField(Ext, FieldName);   { V8.41 simplify }
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqSubjAltNameDNS: String;
begin
   Result := GetReqExtValuesByName('subjectAltName', 'DNS');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqSubjAltNameIP: String;
begin
   Result := GetReqExtValuesByName('subjectAltName', 'IP');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqKeyUsage: String;
begin
    Result := GetReqExtValuesByName('keyUsage', '');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqExKeyUsage: String;
begin
    Result := GetReqExtValuesByName('extendedKeyUsage', '');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqKeyInfo: string;       { V8.52 }
var
    pubkey: PEVP_PKEY;
begin
    result := '' ;
    if NOT Assigned(FX509Req) then Exit;
    pubkey := X509_REQ_get_pubkey(FX509Req);
    Result := GetKeyDesc(pubkey);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqSignAlgo: String;      { V8.52 }
var
    Nid: integer ;
    Str : AnsiString;
begin
    Result := '';
    if NOT Assigned(FX509Req) then Exit;
    Nid := X509_REQ_get_signature_nid(FX509Req);
    if Nid <> NID_undef then begin
        SetLength(Str, 256);
        Str := OBJ_nid2ln(Nid);
        SetLength(Str, IcsStrLen(PAnsiChar(Str)));
        Result := String(Str);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.GetReqCertInfo: String;
begin
    Result := 'Request for (CN): ' + IcsUnwrapNames (ReqSubjCName);
    if ReqSubjOName <> '' then
        Result := Result + ', (O): ' + IcsUnwrapNames (ReqSubjOName) + #13#10
    else
        Result := Result + #13#10;
    if ReqSubjAltNameDNS <> '' then
        Result := Result + 'Alt Domains: ' + IcsUnwrapNames (ReqSubjAltNameDNS) + #13#10;
    if ReqSubjAltNameIP <> '' then
        Result := Result + 'Alt IPs: ' + IcsUnwrapNames (ReqSubjAltNameIP) + #13#10;
    if ReqKeyUsage <> '' then
        Result := Result + 'Key Usage: ' + IcsUnwrapNames(ReqKeyUsage) + #13#10;
    if ReqExKeyUsage <> '' then
        Result := Result + 'Extended Key Usage: ' + IcsUnwrapNames(ReqExKeyUsage) + #13#10;
    Result := Result + 'Signature: ' + ReqSignAlgo + #13#10;
    Result := Result + 'Public Key: ' + ReqKeyInfo;

end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslCertTools.SetCertExt(Cert: PX509; Nid: integer; const List: AnsiString);
var
    Ex: PX509_EXTENSION;
begin
    if List = '' then exit;
    Ex := X509V3_EXT_conf_nid(nil, nil, Nid, PAnsiChar(List));
    if not Assigned(Ex) then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to add extension to certificate, Nid ' + IntToStr (Nid));
    X509_add_ext(cert, Ex, -1);
    X509_EXTENSION_free(Ex);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.BuildBasicCons(IsCA: Boolean): AnsiString;
begin
    if IsCA then begin
        Result := 'critical,CA:TRUE';
        if FBasicPathLen >= 0 then    { V9.1 -1 leave out pathlen for root certificates }
            Result := Result + ', pathlen:' + IcsIntToStrA(FBasicPathLen); // 0=not sign other CAs
    end
    else
        Result := 'critical,CA:FALSE';
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.BuildKeyUsage: AnsiString;
begin
    Result := '';
    if FKeyCertSign then Result := Result + ', keyCertSign';
    if FKeyCRLSign  then Result := Result + ', cRLSign';
    if FKeyDigiSign then Result := Result + ', digitalSignature';
    if FKeyDataEnc  then Result := Result + ', dataEncipherment';
    if FKeyKeyEnc   then Result := Result + ', keyEncipherment';
    if FKeyKeyAgree then Result := Result + ', keyAgreement';
    if FKeyNonRepud then Result := Result + ', nonRepudiation';
    { others: encipherOnly, decipherOnly }
    if Result <> '' then Result := 'critical' + Result;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.BuildExKeyUsage: AnsiString;
begin
    Result := '';
    if FKeyExtClient then Result := Result + ', clientAuth';
    if FKeyExtServer then Result := Result + ', serverAuth';
    if FKeyExtEmail  then Result := Result + ', emailProtection';
    if FKeyExtCode   then Result := Result + ', codeSigning';
    if Result <> '' then Result := Copy (Result, 3, 999);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ build stack of extension multiple values from combined list of different types }
function TSslCertTools.BuildAltStackAll: PStack;
var
    I: Integer;
    ASocketFamily: TSocketFamily;
    ConvOk: Boolean;
    v4Addr: TIcsIPv4Address;
    v6Addr: TIcsIPv6Address;
begin
    result := OPENSSL_sk_new_null;
    if FTotAltItems = 0 then Exit;
    SetLength (FAltAnsiStr, FTotAltItems);    { V8.50 separate memory to allow stack to be built }
    SetLength (FAltIa5Str, FTotAltItems);
    SetLength (FAltGenStr, FTotAltItems);
    for I := 0 to FTotAltItems - 1 do begin
        FAltGenStr[I] := GENERAL_NAME_new;
        if NOT Assigned(FAltGenStr[I]) then Exit;
        FAltIa5Str[I] := ASN1_STRING_new;
        if NOT Assigned(FAltIa5Str[I]) then Exit;
        if FAltItems[I].AltType = GEN_IPADD then begin  { V8.64 IP saved in binary }
            if NOT WSocketIsIP(String(FAltItems[I].AltName), ASocketFamily) then
                FAltAnsiStr[I] := FAltItems[I].AltName
            else begin
                if ASocketFamily = sfIPv4 then begin
                     v4Addr := WSocketStrToIPv4(String(FAltItems[I].AltName), ConvOk);
                     SetLength(FAltAnsiStr[I], 4);
                     Move(v4Addr,  FAltAnsiStr[I] [1], 4);
                end;
                if ASocketFamily = sfIPv6 then begin
                     v6Addr := WSocketStrToIPv6(String(FAltItems[I].AltName), ConvOk);
                     SetLength(FAltAnsiStr[I], 16);
                     Move(v6Addr,  FAltAnsiStr[I] [1], 16);
                end;
            end;
        end
        else
            FAltAnsiStr[I] := FAltItems[I].AltName;
        if FAltAnsiStr[I] <> '' then begin    { V8.50 skip blanks }
            if ASN1_STRING_set(FAltIa5Str[I], PAnsiChar(FAltAnsiStr[I]), Length(FAltAnsiStr[I])) = 0 then   { V8.50 was set0 }
                RaiseLastOpenSslError(ECertToolsException, FALSE, 'Invalid subject_alt_name: ' + String(FAltItems[I].AltName));
            GENERAL_NAME_set0_value(FAltGenStr[I], FAltItems[I].AltType, FAltIa5Str[I]);
            OPENSSL_sk_push(result, Pointer(FAltGenStr[I]));
        end;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ clear alt extension stack }
procedure TSslCertTools.ClearAltStack;
begin
    SetLength (FAltAnsiStr, 0);
    SetLength (FAltGenStr, 0);
    SetLength (FAltIa5Str, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ build stack for an X509 certificate }
procedure TSslCertTools.BuildCertAltSubjAll(Cert: PX509);  { V8.64 }
var
    MultiValuesStack : PStack;
begin
    if FTotAltItems = 0 then Exit;
    MultiValuesStack := BuildAltStackAll;
    if NOT Assigned(MultiValuesStack) then Exit;
    try
        if X509_add1_ext_i2d(Cert, NID_subject_alt_name, MultiValuesStack, 0, 0) = 0 then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to set subject_alt_name');
    finally
        OPENSSL_sk_free(MultiValuesStack);
        ClearAltStack;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ combine various alternate names into sincle list from properties }
procedure TSslCertTools.BuildAltPropList;  { V8.64 }
var
    I, J: Integer;
    ErrFlag, CheckFlag: Boolean;
begin
    FTotAltItems := FAltDNSList.Count + FAltIPList.Count + FAltEmailList.Count;
    SetLength(FAltItems, FTotAltItems);
    if FTotAltItems = 0 then Exit;
    J := 0;

  { subject alternate name - DNS or domain names }
    if FAltDNSList.Count <> 0 then begin
        for I := 0 to FAltDNSList.Count - 1 do begin
            CheckFlag := (Pos('*', FAltDNSList[I]) = 0);  // wild card will fail domain name check
         { V8.64 convert domain to A-Label }
            FAltItems[J].AltName := AnsiString(IcsIDNAToASCII(IcsTrim(FAltDNSList[I]), CheckFlag, ErrFlag));
            FAltItems[J].AltType := GEN_DNS;
            J := J + 1;
        end;
    end;

  { subject alternate name - IP addresses }
    if FAltIPList.Count <> 0 then begin
        for I := 0 to FAltIPList.Count - 1 do begin
            FAltItems[J].AltName := AnsiString(IcsTrim(FAltIPList[I]));
            FAltItems[J].AltType := GEN_IPADD;
            J := J + 1;
        end;
    end;

  { subject alternate name - email addresses }
    if FAltEmailList.Count <> 0 then begin
        for I := 0 to FAltEmailList.Count - 1 do begin
            FAltItems[J].AltName := AnsiString(IcsTrim(FAltEmailList[I]));
            FAltItems[J].AltType := GEN_EMAIL;
            J := J + 1;
        end;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ combine various alternate names into sincle list from properties }
procedure TSslCertTools.BuildAltReqList;  { V8.64 }
var
    I, J: Integer;
    AltItems: String;
    TempList: TStringList;
begin
    FTotAltItems := 0;
    TempList := TStringList.Create;
    try
        AltItems :=  ReqSubjAltNameDNS;
        J := 0;
        if AltItems <> '' then begin
            TempList.Text := AltItems;
            if TempList.Count > 0 then begin
                FTotAltItems := TempList.Count;
                SetLength(FAltItems, FTotAltItems);
                for I := 0 to TempList.Count - 1 do begin
                    FAltItems[J].AltName := AnsiString(IcsTrim(TempList[I]));
                    FAltItems[J].AltType := GEN_DNS;
                    J := J + 1;
                end;
            end;
        end;
        AltItems :=  ReqSubjAltNameIP;
        J := 0;
        if AltItems <> '' then begin
            TempList.Text := AltItems;
            if TempList.Count > 0 then begin
                FTotAltItems := FTotAltItems + TempList.Count;
                SetLength(FAltItems, FTotAltItems);
                for I := 0 to TempList.Count - 1 do begin
                    FAltItems[J].AltName := AnsiString(IcsTrim(TempList[I]));
                    FAltItems[J].AltType := GEN_IPADD;
                    J := J + 1;
                end;
            end;
        end;
    finally
        TempList.Free;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ A certificate request is the second step in acquiring a commercial X509 }
{ certificate (usually paid) from a certificate issuing authority. }
{ A private key needs to be created first, then all the certificate subject }
{ properties such as domain name, company name, etc, are specified and an }
{ X509 Request is created.  The request should be passed to the chosen }
{ certificate authority who will create a new X509 certificate signed by }
{ one of their issuing certificates.  For the new X509 certificate to be }
{ trusted by SSL/TLS applications, the issuing certificate needs to installed }
{ in a local root certificate store, which is normally part of the browser or
{ other software.  Often, the CA will use an intermediate certificate which
{ is itself signed by a root certificate, and this intermediate certificiate }
{ needs to be installed on the SSL/TLS server with the X509 certificate so it
{ is sent to clients.   }
{ This method needs PrivateKey completed, and creates the request }
{ in X509Req from where is may be saved by SaveReqTo.   }
procedure TSslCertTools.DoCertReqProps;

  procedure Add_Ext(sk :PSTACK_OF_X509_EXTENSION; Nid :Integer; const Value :AnsiString);
  var
      Ext : PX509_EXTENSION;
  begin
      if Value = '' then Exit;
      Ext := X509V3_EXT_conf_nid(nil, nil, NID, PAnsiChar(value));
      if not Assigned(Ext) then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to create extension');
      OPENSSL_sk_push(sk, Pointer(ext));
  end;

 { build stack for an X509 certificate request }
    procedure BuildReqAltSubjAll(sk :PSTACK_OF_X509_EXTENSION);  { V8.64 }
    var
        MultiValuesStack : PStack;
    begin
        if FTotAltItems = 0 then Exit;
        MultiValuesStack := BuildAltStackAll;
        if NOT Assigned(MultiValuesStack) then Exit;
        try
          if X509V3_add1_i2d(@sk, NID_subject_alt_name, MultiValuesStack, 0, 0) = 0 then
                RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to create extension Altname stack');
        finally
            OPENSSL_sk_free(MultiValuesStack);
            ClearAltStack;
        end;
    end;


var
    SubjName  : PX509_NAME;
    Exts      : PSTACK_OF_X509_EXTENSION;
    AName     : String;  { V8.64 }
    ErrFlag, CheckFlag : Boolean;
begin
    InitializeSsl;
    if NOT Assigned(PrivateKey) then
        raise ECertToolsException.Create('Must create private key first');

 { V8.64 convert domain to A-Label (Punycode ASCII, validate for allowed characters }
    if (NOT FBasicIsCA) and FKeyExtServer then begin {  V8.71 only for server certs, not email or client  }
        CheckFlag := (Pos('*', FCommonName) = 0);  // wild card will fail domain name check
        AName := IcsIDNAToASCII(IcsTrim(FCommonName), CheckFlag, ErrFlag);
        if ErrFlag then
            raise ECertToolsException.Create('Invalid Common Name, Illegal Characters');
        end
    else
        AName := IcsTrim(FCommonName); // CA is usually a company name, not a domain

    if Assigned(FNewReq) then X509_REQ_free(FNewReq);
    FNewReq := X509_Req_new;
    if NOT Assigned(FNewReq) then
         raise ECertToolsException.Create('Can not create new request object');

   if X509_REQ_set_version(FNewReq, 0) = 0 then   // V9.4 requests are always version 1, ie 0
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to set version in request');

    if X509_REQ_set_pubkey(FNewReq, PrivateKey) = 0 then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to add public key to request');

    SubjName := X509_REQ_get_subject_name(FNewReq);  { V8.66 }
    if not Assigned(SubjName) then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Can not read X509 subject_name');
    AddNameEntryByTxt(SubjName, 'CN', AName);      { V8.64 }
    AddNameEntryByTxt(SubjName, 'OU', FOrgUnit);
    AddNameEntryByTxt(SubjName, 'ST', FState);
    AddNameEntryByTxt(SubjName, 'O', FOrganization);
    AddNameEntryByTxt(SubjName, 'C', FCountry);
    AddNameEntryByTxt(SubjName, 'L', FLocality);
    AddNameEntryByTxt(SubjName, 'GN', FGivenName);      { V9.5 }
    AddNameEntryByTxt(SubjName, 'SN', FSurName);        { V9.5 }
    AddNameEntryByTxt(SubjName, 'initials', FNameInitials);   { V9.5 }
    AddNameEntryByNid(SubjName, 107, FDescr);     { V9.5 OpenSSL no object NID_description  }
    AddNameEntryByTxt(SubjName, 'street', FStreet);     { V9.5 }
    AddNameEntryByTxt(SubjName, 'title', FNameTitle);       { V9.5 }

    if Length(AnsiString(FEmail)) > 0 then
        X509_NAME_add_entry_by_NID(SubjName, NID_pkcs9_emailAddress, MBSTRING_ASC, PAnsiChar(AnsiString(FEmail)), -1, -1, 0);

 { add extensions - create new stack  }
    Exts := OPENSSL_sk_new_null;
    Add_Ext(Exts, NID_key_usage, BuildKeyUsage);

  { Extended Key usage }
    Add_Ext(Exts, NID_ext_key_usage, BuildExKeyUsage);

  { subject alternate names }
  { V8.64 add DNS, IPs and emails together, previously only one }
    BuildAltPropList;
    BuildReqAltSubjAll(Exts);

 { finally add stack of extensions to request }
    if X509_REQ_add_extensions(FNewReq, Exts) = 0 then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to add extensions to request');
    OPENSSL_sk_pop_free(Exts, @X509_EXTENSION_free);

 { sign request with private key and digest/hash }
    if EVP_PKEY_get_base_id(PrivateKey) = EVP_PKEY_ED25519 then begin   { V8.51 no digest for EVP_PKEY_ED25519 }
        if X509_REQ_sign(FNewReq, PrivateKey, Nil) = 0 then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to sign request with ED25519 key');
    end
    else begin
        if X509_REQ_sign(FNewReq, PrivateKey, IcsSslGetEVPDigest(FCertDigest)) = 0 then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to sign request with digest');
    end;
    SetX509Req(FNewReq);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ similar to DoCertReqProps but creates a new X509 certificate request from }
{ an existing certificate, ie to renew a expiring certificate. }
{ This method needs X509 and PrivateKey completed, and creates }
{ the request in X509Req from where is may be saved by SaveReqTo.   }
procedure TSslCertTools.DoCertReqOld;
begin
    InitializeSsl;
    if NOT Assigned(X509) then
        raise ECertToolsException.Create('Must open old certificate first');
    if NOT Assigned(PrivateKey) then
        raise ECertToolsException.Create('Must create private key first');
    if X509_check_private_key(X509, PrivateKey) < 1 then
        raise ECertToolsException.Create('Old certificate and private key do not match');

  { create new request from old certificate - warning ignores alternate subject DNS }
    if Assigned(FNewReq) then X509_REQ_free(FNewReq);
    if EVP_PKEY_get_base_id(PrivateKey) = EVP_PKEY_ED25519 then    { V8.51 no digest for EVP_PKEY_ED25519 }
        FNewReq := X509_to_X509_REQ(X509, PrivateKey, Nil)
    else
        FNewReq := X509_to_X509_REQ(X509, PrivateKey, IcsSslGetEVPDigest(FCertDigest));
    if NOT Assigned (FNewReq) then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to sign request with digest');
     SetX509Req(FNewReq);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ create a self signed certificate from properties or request and private key }
procedure TSslCertTools.DoSelfSignCert(UseCSR: Boolean = False);   { V8.57 added UseCSR }
var
    SubjName  : PX509_NAME;
    AName     : String;  { V8.64 }
    ErrFlag, CheckFlag : Boolean;
begin
    InitializeSsl;
    if NOT Assigned(PrivateKey) then
        raise ECertToolsException.Create('Must create private key first');
    if UseCSR then begin   { V8.57 }
        if NOT Assigned(FX509Req) then
            raise ECertToolsException.Create('Must open certificate request first');
    end;

 { V8.64 convert domain to A-Label (Punycode ASCII, validate for allowed characters }
    if (NOT FBasicIsCA) and FKeyExtServer then begin {  V8.71 only for server certs, not email or client  }
        CheckFlag := (Pos('*', FCommonName) = 0);  // wild card will fail domain name check
        AName := IcsIDNAToASCII(IcsTrim(FCommonName), CheckFlag, ErrFlag);
        if ErrFlag then
            raise ECertToolsException.Create('Invalid Common Name, Illegal Characters');
    end
    else
        AName := IcsTrim(FCommonName); // CA is usually a company name, not a domain

    if Assigned(FNewCert) then X509_free(FNewCert);
    FNewCert := X509_new;
    if NOT Assigned(FNewCert) then
         RaiseLastOpenSslError(ECertToolsException, FALSE, 'Can not create new X509 object');

   { set version, serial number, expiry }
    if X509_set_version(FNewCert, 2) = 0 then   // v3
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to set version to certificate');;
    if FSerialNum = 0 then begin
        FSerialNum := IcsMakeLongLong(IcsRandomInt($7FFFFFFF), IcsRandomInt($7FFFFFFF));  { V8.65 }
    end;
    if FExpireDays < 7 then FExpireDays := 7;  { V8.62 was 30 }
    ASN1_INTEGER_set_int64(X509_get_serialNumber(FNewCert), FSerialNum);
    X509_gmtime_adj(X509_get0_notBefore(FNewCert), 0);                                { V8.66 }
    X509_gmtime_adj(X509_get0_notAfter(FNewCert), 60 * 60 * 24 * FExpireDays);        { V8.66 }

    if X509_set_pubkey(FNewCert, PrivateKey) = 0 then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to add public key to certificate');

 { V8.57 see if using CSR for out new certificate }
    if UseCSR then begin

      { set the cert subject name to the request subject }
        SubjName := X509_NAME_dup(X509_REQ_get_subject_name(X509Req));       { V8.66 }
        if NOT Assigned(SubjName) or (X509_set_subject_name(FNewCert, SubjName) = 0) then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to set subject from request');

      { It's self signed so set the issuer name to be the same as the subject. }
        X509_set_issuer_name(FNewCert, SubjName);

      { Add basic contraints }
        SetCertExt(FNewCert, NID_basic_constraints, BuildBasicCons(FBasicIsCA));

     { copy some extension from request to certificate }
        BuildAltReqList;  { V8.64 }
        BuildCertAltSubjAll(FNewCert);

     { Key usage }
        SetCertExt(FNewCert, NID_key_usage, AnsiString(IcsUnwrapNames(ReqKeyUsage)));

    { Extended Key usage }
        SetCertExt(FNewCert, NID_ext_key_usage, AnsiString(IcsUnwrapNames(ReqExKeyUsage)));
    end

 { build certificate from properties }
    else begin

    { build certificate subject name as one line
      ie Subject: C=GB, ST=Surrey, L=Croydon, O=Magenta Systems Ltd, CN=Magenta Systems Ltd }
        SubjName := X509_get_subject_name(FNewCert);
        if not Assigned(SubjName) then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Can not read X509 subject_name');
        AddNameEntryByTxt(SubjName, 'CN', AName);      { V8.64 }
        AddNameEntryByTxt(SubjName, 'OU', FOrgUnit);
        AddNameEntryByTxt(SubjName, 'ST', FState);
        AddNameEntryByTxt(SubjName, 'O',  FOrganization);
        AddNameEntryByTxt(SubjName, 'C',  FCountry);
        AddNameEntryByTxt(SubjName, 'L',  FLocality);
        AddNameEntryByTxt(SubjName, 'GN', FGivenName);      { V9.5 }
        AddNameEntryByTxt(SubjName, 'SN', FSurName);        { V9.5 }
        AddNameEntryByTxt(SubjName, 'initials', FNameInitials);   { V9.5 }
        AddNameEntryByNid(SubjName, 107, FDescr);     { V9.5 OpenSSL no object NID_description  }
        AddNameEntryByTxt(SubjName, 'street', FStreet);     { V9.5 }
        AddNameEntryByTxt(SubjName, 'title', FNameTitle);       { V9.5 }

        if Length(AnsiString(FEmail)) > 0 then
            X509_NAME_add_entry_by_NID(SubjName, NID_pkcs9_emailAddress, MBSTRING_ASC, PAnsiChar(AnsiString(FEmail)), -1, -1, 0);

      { It's self signed so set the issuer name to be the same as the subject. }
        X509_set_issuer_name(FNewCert, SubjName);

      { Add basic contraints }
        SetCertExt(FNewCert, NID_basic_constraints, BuildBasicCons(FBasicIsCA));

      { Key usage }
        SetCertExt(FNewCert, NID_key_usage, BuildKeyUsage);

      { Extended Key usage }
        SetCertExt(FNewCert, NID_ext_key_usage, BuildExKeyUsage);

      { subject alternate names }
      { V8.64 add DNS, IPs and emails together, previously only one }
        BuildAltPropList;
        BuildCertAltSubjAll(FNewCert);
    end;

  { Issuer Alternative Name. }
    if FAltIssuer <> '' then begin
        SetCertExt(FNewCert, NID_issuer_alt_name, AnsiString(FAltIssuer));
    end;

  { CRL distribution points - URI:http://myhost.com/myca.crl }
    if FCRLDistPoint <> '' then begin
        SetCertExt(FNewCert, NID_crl_distribution_points, AnsiString(FCRLDistPoint));
    end;

  { Authority Info Access - OCSP;URI:http://ocsp.myhost.com/ }
    if FAuthInfoAcc <> '' then begin
        SetCertExt(FNewCert, NID_info_access, AnsiString(FAuthInfoAcc));
    end;

  { V8.62 acmeIdentifier "1.3.6.1.5.5.7.1.31" or OBJ_id_pe,31L, dynamically created NID, expecting binary sha256 digest in hex }
    if Length(FAcmeIdentifier) > 0 then begin
        SetCertExt(FNewCert, ICS_NID_acmeIdentifier,  AnsiString('critical,DER:04:20:' + FAcmeIdentifier));  // octet string(4), 32 long, converted from hex to binary
    end;

  { self sign it with our key and hash digest }
    if EVP_PKEY_get_base_id(PrivateKey) = EVP_PKEY_ED25519 then begin   { V8.51 no digest for EVP_PKEY_ED25519 }
        if X509_sign(FNewCert, PrivateKey, Nil) = 0 then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to sign certifcate with ED25519 key');
    end
    else begin
        if X509_sign(FNewCert, PrivateKey, IcsSslGetEVPDigest(FCertDigest)) <= 0 then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to sign certificate with digest');
    end;
    SetX509(FNewCert);

  { add certificate to our database ? }
  { note this is done in OverbyteIcsSslX509Certs }
 end;


 {* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function TSslCertTools.SaveToCADatabase(const CertFName: String = 'unknown'): Boolean;
var
    FStream: TFileStream;
    CertRec: String;
const
  DateTimeMask = 'yymmddhhnnss"Z"';
begin
    Result := False;
    if FCADBFile = '' then Exit;
    if NOT IsCertLoaded then Exit;

// CA database record, similar to OpenSSL but with SANs on the end
// 1 - status - V=valid, R=revoked, E=expired
// 2 - cert expire date
// 3 - cert revoked date (empty is not)
// 4 - serial number in hex
// 5 - cert file name or 'unknown'
// 6 - cert subject including common name
// 7 - cert subject alternate names
    CertRec := 'V' + IcsTAB + FormatDateTime(DateTimeMask, ValidNotAfter) +
                  IcsTAB + {no revoke data } IcsTAB + SerialNumHex + IcsTAB + CertFName +
                          IcsTAB + SubjectOneLine + IcsTAB + IcsUnwrapNames(GetSubjectAltName.Value) + icsCRLF;
        //  IcsUnwrapNames(SubAltNameDNS) + icsCRLF;

    if NOT ForceDirectories (ExtractFileDir (FCADBFile)) then
        raise ECertToolsException.Create('Failed to create CA DB Directory: ' + FCADBFile);
    FStream := Nil;
    try
        if NOT FileExists((FCADBFile)) then
            FStream := TFileStream.Create (FCADBFile, fmCreate)
        else begin
            FStream := TFileStream.Create (FCADBFile, fmOpenReadWrite OR fmShareDenyWrite);
            FStream.Seek(0, soEnd);
        end;
        FStream.WriteBuffer(AnsiString(CertRec) [1], Length (CertRec));
        Result := True;
    finally
        FStream.Free;
    end;
end ;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ create a new CA signed certificate from a certificate request }
{ need to create a CA certificate (X509CA) and private key (PrivKeyCA) first }
{ not finished, does not copy extensions }
procedure TSslCertTools.DoSignCertReq(CopyExtns: Boolean);
var
    SubjName  : PX509_NAME;
begin
    InitializeSsl;
    if NOT Assigned(FX509CA) then
        raise ECertToolsException.Create('Must open CA certificate first');
    if NOT Assigned(FX509Req) then
        raise ECertToolsException.Create('Must open certificate request first');
    if NOT Assigned(FPrivKeyCA) then
        raise ECertToolsException.Create('Must open CA private key first');
    if X509_check_private_key(FX509CA, FPrivKeyCA) = 0 then
        raise ECertToolsException.Create('CA certificate and private key do not match');

    if Assigned(FNewCert) then X509_free(FNewCert);
    FNewCert := X509_new;
    if NOT Assigned(FNewCert) then
         RaiseLastOpenSslError(ECertToolsException, FALSE, 'Can not create new X509 object');

   { set version, serial number, expiry and public key }
    if X509_set_version(FNewCert, 2) = 0 then  { version 3}
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to set version to certificate');
    if FSerialNum = 0 then begin
        FSerialNum := IcsMakeLongLong(IcsRandomInt($7FFFFFFF), IcsRandomInt($7FFFFFFF));  { V8.65 }
    end;
    if FExpireDays < 7 then
        FExpireDays := 7;   { V8.62 was 30 }
    if ASN1_INTEGER_set_int64(X509_get_serialNumber(FNewCert), FSerialNum) = 0 then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to set serial num');
    X509_gmtime_adj(X509_get0_notBefore(FNewCert), 0);                              { V8.66 }
    X509_gmtime_adj(X509_get0_notAfter(FNewCert), 60 * 60 * 24 * FExpireDays);      { V8.66 }

  { public key from request, not CA }
    if X509_set_pubkey(FNewCert, X509_REQ_get0_pubkey(X509Req)) = 0 then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to set public key to certificate');

  { set the cert subject name to the request subject }
    SubjName := X509_NAME_dup(X509_REQ_get_subject_name(X509Req));                 { V8.66 }
    if NOT Assigned(SubjName) or (X509_set_subject_name(FNewCert, SubjName) = 0) then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to set subject from request');

  { set the issuer name to CA subject }
    if X509_set_issuer_name(FNewCert, X509_get_subject_name(FX509CA)) = 0 then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to set issuer from CA');

  { set extensions }

  { Add basic contraints }
    SetCertExt(FNewCert, NID_basic_constraints, BuildBasicCons(FBasicIsCA));

     if NOT CopyExtns then begin

      { subject alternate names }
      { V8.64 add DNS, IPs and emails together, previously only one }
        BuildAltPropList;
        BuildCertAltSubjAll(FNewCert);

     { Key usage }
        SetCertExt(FNewCert, NID_key_usage, BuildKeyUsage);

    { Extended Key usage }
        SetCertExt(FNewCert, NID_ext_key_usage, BuildExKeyUsage);

    end
    else begin
     { copy some extension from request to certificate }
        BuildAltReqList;  { V8.64 }
        BuildCertAltSubjAll(FNewCert); { V8.64 }

     { Key usage }
        SetCertExt(FNewCert, NID_key_usage, AnsiString(IcsUnwrapNames(ReqKeyUsage)));

    { Extended Key usage }
        SetCertExt(FNewCert, NID_ext_key_usage, AnsiString(IcsUnwrapNames(ReqExKeyUsage)));

    end;

  { Sign it with CA certificate and hash digest }
     if EVP_PKEY_get_base_id(FPrivKeyCA) = EVP_PKEY_ED25519 then begin   { V8.51 no digest for EVP_PKEY_ED25519 }
        if X509_sign(FNewCert, FPrivKeyCA, Nil) = 0 then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to sign certifcate with ED25519 key');
    end
    else begin
       if X509_sign(FNewCert, FPrivKeyCA, IcsSslGetEVPDigest(FCertDigest)) <= 0 then
        RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to sign certificate with digest');
    end;
    SetX509(FNewCert);
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function BNGENCBcallFunc(p: Integer; n: Integer; cb: PBN_GENCB): Integer; {$IFNDEF YuOpenSSL}cdecl;{$ENDIF}
var
//    c: AnsiChar;
    Arg: Pointer;
    CertTools: TSslCertTools;
begin
    result := 1; // success, will 0 cause the function to fail??
    if NOT Assigned(cb) then Exit;
    try
        Arg := BN_GENCB_get_arg(cb);
        if NOT Assigned (Arg) then exit;
        CertTools := TSslCertTools(Arg);
        with CertTools do begin
          { good idea to call ProcessMessages in event so program remains responsive!!! }
            if Assigned(CertTools.FOnKeyProgress) then
                    CertTools.FOnKeyProgress(CertTools);
        end;
    except
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function EVPPKEYCBcallFunc(pctx: PEVP_PKEY_CTX): Integer; {$IFNDEF YuOpenSSL}cdecl;{$ENDIF}
var
    Arg: Pointer;
    CertTools: TSslCertTools;
begin
    result := 1; // success, will 0 cause the function to fail??
    if NOT Assigned(pctx) then Exit;
    try
        Arg := EVP_PKEY_CTX_get_app_data(pctx);
        if NOT Assigned (Arg) then exit;
        CertTools := TSslCertTools(Arg);
        with CertTools do begin
          { good idea to call ProcessMessages in event so program remains responsive!!! }
            if Assigned(CertTools.FOnKeyProgress) then
                    CertTools.FOnKeyProgress(CertTools);
        end;
    except
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Creating a key pair is the first step in creating X509 certificates.  }
{ The private key must be kept secure and never distributed, it will be }
{ needed to use the X509 certificate with an SSL server or client, to sign }
{ X509 certificate requests or self signed X509 certificates or to sign }
{ other documents.  The public key may be extracted from the private key. }
{ The public key is added to the X509 certificate and request and is not
{ normally needed as a separate file }
{ This method creates a new key pair in Privatekey using RSA or EC
{ Elliptic Curve) methods with varying key sizes according to the PrivKeyType
{ property. Various SaveTo methods may be used to write the keys to files, }
{ optionally encrypted with a password to protect it.   }
procedure TSslCertTools.DoKeyPair;
var
    Bits, KeyNid, CurveNid: Integer;
    Pctx: PEVP_PKEY_CTX;      { V8.49 total rewrite uising these methods }
    KeyInfo: string;
begin
    InitializeSsl;
    if NOT ICS_RAND_INIT_DONE then IcsRandPoll;
 //   callback := Nil;

 { note private keys can use DSA, but this is now obsolete }
    if Assigned(FPrivKey) then
        EVP_PKEY_free(FPrivKey);   { V8.49 free and new }
    FPrivKey := Nil;

    CurveNid := 0;
    Bits := 0;
    if (FPrivKeyType >= PrivKeyRsa1024) and (FPrivKeyType <= PrivKeyRsa15360) then begin
        KeyNid := EVP_PKEY_RSA;
        KeyInfo := 'RSA';
        case FPrivKeyType of
            PrivKeyRsa1024:  Bits := 1024;
            PrivKeyRsa2048:  Bits := 2048;
            PrivKeyRsa3072:  Bits := 3072;
            PrivKeyRsa4096:  Bits := 4096;
            PrivKeyRsa7680:  Bits := 7680;
            PrivKeyRsa15360: Bits := 15360;
        else
            Bits := 2048;
        end;
    end
    else if (FPrivKeyType = PrivKeyEd25519) then begin   { V8.50 needs OpenSSL 1.1.1 }
        KeyNid := EVP_PKEY_ED25519;
        KeyInfo := 'ED25519';
    end
    else if (FPrivKeyType >= PrivKeyRsaPss2048) and (FPrivKeyType <= PrivKeyRsaPss15360) then begin    { V8.51 needs OpenSSL 1.1.1 }
        KeyNid := EVP_PKEY_RSA_PSS;
        KeyInfo := 'RSA-PSS';
        case FPrivKeyType of
            PrivKeyRsaPss2048:  Bits := 2048;
            PrivKeyRsaPss3072:  Bits := 3072;
            PrivKeyRsaPss4096:  Bits := 4096;
            PrivKeyRsaPss7680:  Bits := 7680;
            PrivKeyRsaPss15360: Bits := 15360;
        else
            Bits := 2048;
        end;
    end
    else if (FPrivKeyType >= PrivKeyECsecp256) and (FPrivKeyType <= PrivKeyECsecp512) then begin
        KeyNid := EVP_PKEY_EC;
        KeyInfo := 'EC';
        case FPrivKeyType of
            PrivKeyECsecp256:  CurveNid := NID_X9_62_prime256v1;  // aka secp256r1
            PrivKeyECsecp384:  CurveNid := NID_secp384r1;
            PrivKeyECsecp512:  CurveNid := NID_secp521r1;
            PrivKeyECsecp256k: CurveNid := NID_secp256k1;      { V8.67 Kobitz curve }
            else
                CurveNid := NID_X9_62_prime256v1;
        end;
    end
    else begin
        RaiseLastOpenSslError(ECertToolsException, true, 'Unknown Private Key Type');  { V8.64 need an error }
        Exit;
    end;

 { initialise context for private keys }
    Pctx := EVP_PKEY_CTX_new_id(KeyNid, Nil);
    if NOT Assigned(Pctx) then
            RaiseLastOpenSslError(ECertToolsException, true, 'Failed to create new ' + KeyInfo + ' key');
    if EVP_PKEY_keygen_init(Pctx) = 0 then
            RaiseLastOpenSslError(ECertToolsException, true, 'Failed to init ' + KeyInfo + ' keygen');
    if (KeyNid = EVP_PKEY_RSA) or (KeyNid = EVP_PKEY_RSA_PSS) then begin
        if (Bits > 0) and (EVP_PKEY_CTX_set_rsa_keygen_bits(Pctx, Bits) = 0) then
            RaiseLastOpenSslError(ECertToolsException, true, 'Failed to set RSA bits');
         // EVP_PKEY_CTX_set_rsa_padding
         // EVP_PKEY_CTX_set_signature_md
    end;
    if (CurveNid > 0) and (EVP_PKEY_CTX_set_ec_paramgen_curve_nid(Pctx, CurveNid) = 0) then
                RaiseLastOpenSslError(ECertToolsException, true, 'Failed to set EC curve');
    if (KeyNid = EVP_PKEY_RSA_PSS) then begin
        // pending - various macros to restrict digests, MGF1 and minimum salt length
        // EVP_PKEY_CTX_set_rsa_pss_keygen_md
        // EVP_PKEY_CTX_set_rsa_pss_saltlen
        // EVP_PKEY_CTX_set_rsa_pss_keygen_mgf1_md
    end;


  { progress callback, really only needed for slow RSA }
    EVP_PKEY_CTX_set_app_data(Pctx, Self);
    EVP_PKEY_CTX_set_cb(Pctx, @EVPPKEYCBcallFunc);

  { generate private key pair }
    if EVP_PKEY_keygen(Pctx, @FPrivKey) = 0 then
            RaiseLastOpenSslError(ECertToolsException, true, 'Failed to generate ' + KeyInfo + ' key');
    if NOT Assigned(FPrivKey) then
            RaiseLastOpenSslError(ECertToolsException, true, 'Failed to create new ' + KeyInfo + ' key, empty');
    SetPrivateKey(FPrivKey);
    EVP_PKEY_CTX_free(Pctx);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This method creates DHParams which are needed by servers using DH and DHE
{ key exchange (but not for ECDH and ECDHE).  DHParams are usually created once }
{ for a server or application, if they become known it can speed up cracking. }
{ This method only needs a length and output file name specified. }
{ Beware, very time consuming, 1024 less than a min, 2048 few mins, 4096 few hours, }
{ 8192 gave up after two days, so use the OnKeyProgress event to to call }
{ ProcessMessages in event so program remains responsive!!!   }
function TSslCertTools.DoDHParams(const FileName: String; Bits: integer): String;
{$IFDEF OpenSSL_Deprecated}  { V9.5 }
var
    ABio   : PBIO;
    DhParam   : PDH;
    Ret, Err {, Len} : Integer;
    callback  : PBN_GENCB;
{$ENDIF OpenSSL_Deprecated}   { V9.5 }
begin
    result := '';  { V9.5 no result }
{$IFDEF OpenSSL_Deprecated}  { V9.5 }
    InitializeSsl;
    callback := Nil;
    DhParam := Nil;
    ABio := IcsSslOpenFileBio(FileName, bomWrite);
    if NOT Assigned(ABio) then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to open file = ' + FileName);
    try
      { create progress callback }
        callback := BN_GENCB_new;
        if Assigned(callback) then
            BN_GENCB_set(callback, @BNGENCBcallFunc, Self);

      { generate DHParams }
        DhParam := DH_new;
        Ret := DH_generate_parameters_ex(DhParam, Bits, 2, callback);
        if (Ret = 0) then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to generate DHParams');
        Ret := DH_check(DhParam, @Err);
        if (Ret = 0) then
            RaiseLastOpenSslError(ECertToolsException, FALSE, 'Failed to check DHParams, Error ' + IntToHex (Err, 8));

        ret := PEM_write_bio_DHparams(ABio, DhParam);
        if ret = 0 then
            RaiseLastOpenSslError(EX509Exception, TRUE, 'Error writing DHParams to ' + FileName);
        BIO_free(ABIO);

      { now save params again to string }
        ABio := BIO_new(BIO_s_mem);
        if Assigned(ABio) then begin
            PEM_write_bio_DHparams(ABio, DhParam);
            Result := String(IcsReadStrBio(ABio, 9999));    { V9.1 simplify }
        end;

    finally
        if Assigned(ABIO) then
            BIO_free(ABIO);
        if Assigned(DhParam) then
            DH_free(DhParam);
        if Assigned (callback) then
            BN_GENCB_free(callback);
    end;
{$ENDIF OpenSSL_Deprecated}   { V9.5 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslCertTools.DoClearCerts;
begin
    InitializeSsl;
    X509 := Nil;
    PrivateKey := Nil;
    X509Req := Nil;
    X509Inters := Nil;
    FreeAndNilX509Req;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure TSslCertTools.DoClearCA;  { V8.57 split from DoClearCerts }
begin
    InitializeSsl;
    FreeAndNilX509CA;
    FreeAndNilPrivKeyCA;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ method to create an SSL server certificate bundle file with an SSL certificate,
  matching public key and optional itermediate certificate(s), to avoid
  distributing and loading them all separately, output file format is determined
  by the file extension, PEM, PFX or P12 - no others can have cert and pkey }
procedure TSslCertTools.CreateCertBundle(const CertFile, PKeyFile, InterFile, LoadPw,
                                      SaveFile, SavePw: String; KeyCipher: TSslPrivKeyCipher = PrivKeyEncNone);
begin
    ClearAll;
    LoadFromFile(CertFile, croNo, croTry, '');
    if NOT IsCertLoaded then
        raise Exception.Create('No certificate found 9n file');
    PrivateKeyLoadFromPemFile(PKeyFile, LoadPw);
    if InterFile <> '' then
        LoadIntersFromPemFile(InterFile);
    SaveToFile(SaveFile, true, true, IsInterLoaded, SavePw, KeyCipher);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ OpenSSL 3.0 get private key parameters specified in an array }
{ array must be set-up with one record for each key required and a blank }
function TSslCertTools.GetKeyParams(var Params: POSSL_PARAM): Boolean;  { V8.67 }
begin
    Result := False;
    if ICS_OPENSSL_VERSION_MAJOR < 3 then Exit;
    if NOT Assigned(PrivateKey) then
        raise ECertToolsException.Create('Must create private key first');
    Result := (EVP_PKEY_get_params(PrivateKey, @Params) = 1);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{ V8.41 replaced old code with TSslCertTools component }
procedure CreateSelfSignedCert(const FileName, Country, State,  Locality, Organization, OUnit, CName, Email: String;
                   Bits: Integer; IsCA: Boolean; Days: Integer; const KeyFileName: String = ''; Comment: boolean = false);
var
    MySslCertTools: TSslCertTools;
    KeyType: TSslPrivKeyType;
begin
    MySslCertTools := TSslCertTools.Create(nil);
    try
        MySslCertTools.Country        := Country;
        MySslCertTools.State          := State;
        MySslCertTools.Locality       := Locality;
        MySslCertTools.Organization   := Organization;
        MySslCertTools.OrgUnit        := OUnit;
        MySslCertTools.Email          := EMail;
        MySslCertTools.CommonName     := CName;
        MySslCertTools.BasicIsCA      := IsCA;
        MySslCertTools.ExpireDays     := Days;   { V8.64 got lost }
        if Bits > 4096 then
            KeyType := PrivKeyRsa7680
        else if Bits > 3072 then
            KeyType := PrivKeyRsa4096
        else if Bits > 2048 then
            KeyType := PrivKeyRsa3072
        else if Bits > 1024 then
            KeyType := PrivKeyRsa2048
        else
            KeyType := PrivKeyRsa1024;
        MySslCertTools.PrivKeyType := KeyType;

      { create private and public key, then create SSL certificate }
        MySslCertTools.DoKeyPair;
        MySslCertTools.DoSelfSignCert;

      { now save them to PEM files - no passwords }
        if KeyFileName <> '' then begin
            MySslCertTools.PrivateKeySaveToPemFile(KeyFileName);
            MySslCertTools.SaveToPemFile(FileName, False, Comment, False);
        end
        else begin
            MySslCertTools.SaveToPemFile(FileName, True, Comment, False);
       end;
    finally
        MySslCertTools.Free;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
// create a self signed certificate with subject alternative names, specific
// private key, optionally with ACME tls-alpn-01 challenge identifier
// used by TWSslSocketServer to create certificate if missing so it can start-up
// V9.1 allow signing with an Intermediate CA certificate instead of self signing
procedure CreateSelfSignCertEx(const FileName, CName: String; AltDNSLst: TStrings; PKeyType: TSslPrivKeyType =
           PrivKeyECsecp256; const PW: String = '';  const AcmeId: String = ''; const InterCAFile: String = '');  { V8.64, V9.1 InterCA }
var
    MySslCertTools: TSslCertTools;
    PrivKeyType: TSslPrivKeyCipher;
    ExpDays, I: Integer;
    InterLines: String;
    SocFamily: TSocketFamily;
begin
    MySslCertTools := TSslCertTools.Create(nil);
    try
        ExpDays := 2000;
        if AcmeId <> '' then
            ExpDays := 7
        else if (InterCAFile <> '') then begin
            if (Pos('.', InterCAFile) > 10) and FileExists(InterCAFile) then   { V9.1 load InterCA file }
                MySslCertTools.LoadFromFile(InterCAFile, croYes, croNo, PW)
            else begin
                InterLines := IcsTBytesToString(IcsResourceGetTB('ICSINTERPEM'));  // no file, try linked resource
                if InterLines <> '' then
                    MySslCertTools.LoadFromText(InterLines, croYes, croNo, PW);
            end;
            if MySslCertTools.IsCertLoaded then begin
                if NOT MySslCertTools.IsPKeyLoaded then
                    raise Exception.Create('Certificate Authority Failed to Load');
                if Pos ('CA=TRUE', MySslCertTools.BasicConstraints) = 0 then
                    raise Exception.Create('Certificate Authority is not a CA');
                if Now < MySslCertTools.ValidNotAfter then begin
                    MySslCertTools.X509CA := MySslCertTools.X509;           // for signing
                    MySslCertTools.PrivKeyCA := MySslCertTools.PrivateKey;
                    MySslCertTools.AddtoInters(MySslCertTools.X509);      // for bundle file
                    ExpDays := Trunc(MySslCertTools.ValidNotAfter - Now);  // expire same as intermediate
                end
                else
                    MySslCertTools.ClearAll;  // expired, so self sign instead
            end;
        end;
        MySslCertTools.AltDNSList.Clear;
        MySslCertTools.AltIpList.Clear;
    { V9.5 common name not allowed as an IP address }
        if WSocketIsIP(CName, SocFamily) then begin
            MySslCertTools.CommonName := '';
            if (NOT Assigned(AltDNSLst)) or (AltDNSLst.Count = 0) then
                MySslCertTools.FAltIpList.Add(CName);    { V9.5 add to AltIpLst }
        end
        else begin
            MySslCertTools.CommonName := CName;
        end;
        if (Assigned(AltDNSLst)) and (AltDNSLst.Count > 0) then begin
            for I := 0 to AltDNSLst.Count - 1 do begin
              { V9.5 add host names and IP addresses to correct alternate list }
                if WSocketIsIP(AltDNSLst[I], SocFamily) then
                    MySslCertTools.AltIpList.Add(AltDNSLst[I])
                else
                    MySslCertTools.AltDNSList.Add(AltDNSLst[I]);
            end;
        end;
        MySslCertTools.AcmeIdentifier := AcmeId;
        MySslCertTools.BasicIsCA := False;
        MySslCertTools.PrivKeyType := PKeyType;
        MySslCertTools.ExpireDays := ExpDays;
        MySslCertTools.KeyCertSign := true;
        MySslCertTools.KeyDigiSign := true;
        MySslCertTools.KeyNonRepud := true;
        MySslCertTools.KeyKeyEnc := true;
        MySslCertTools.KeyExtServer := true;

      { create new private and public key }
        MySslCertTools.DoKeyPair;
        if MySslCertTools.IsCALoaded then begin
            MySslCertTools.DoCertReqProps;
            MySslCertTools.DoSignCertReq(False);
        end
        else
         { create self signed SSL certificate }
            MySslCertTools.DoSelfSignCert;

      { now save them to file - no password unless PKX }
        PrivKeyType := PrivKeyEncNone;
        if PW <> '' then
            PrivKeyType := PrivKeyEncAES256;  { V8.67 was PrivKeyEncTripleDES }
        MySslCertTools.SaveToFile(FileName, True, True, MySslCertTools.IsCALoaded, PW, PrivKeyType);
    finally
        MySslCertTools.Free;
    end;
end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ V8.41 replaced old code with TSslCertTools component }
procedure CreateCertRequest(const RequestFileName, KeyFileName, Country, State, Locality, Organization, OUnit,
                                                              CName, Email: String; Bits: Integer; Comment: boolean = false);
var
    MySslCertTools: TSslCertTools;
    KeyType: TSslPrivKeyType;
begin
    MySslCertTools := TSslCertTools.Create(nil);
    try
        MySslCertTools.Country        := Country;
        MySslCertTools.State          := State;
        MySslCertTools.Locality       := Locality;
        MySslCertTools.Organization   := Organization;
        MySslCertTools.OrgUnit        := OUnit;
        MySslCertTools.Email          := EMail;
        MySslCertTools.CommonName     := CName;
        if Bits > 4096 then
            KeyType := PrivKeyRsa7680
        else if Bits > 3072 then
            KeyType := PrivKeyRsa4096
        else if Bits > 2048 then
            KeyType := PrivKeyRsa3072
        else if Bits > 1024 then
            KeyType := PrivKeyRsa2048
        else
            KeyType := PrivKeyRsa1024;
        MySslCertTools.PrivKeyType := KeyType;

      { create private and public key, then create certificate request }
        MySslCertTools.DoKeyPair;
        MySslCertTools.DoCertReqProps;

      { now save them to PEM files - no passwords }
        MySslCertTools.PrivateKeySaveToPemFile(KeyFileName);
        MySslCertTools.SaveReqToFile(RequestFileName, Comment);
    finally
        MySslCertTools.Free;
    end;
end;



{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
 {$IFDEF OpenSSL_Deprecated}  { V9.5 }
function EncryptPublicRSA(
    PubKey      : PEVP_PKEY;
    InBuf       : Pointer;
    InLen       : Cardinal;
    OutBuf      : Pointer;
    var OutLen  : Cardinal;
    Padding     : TRsaPadding): Boolean;
var
    Bytes     : Word;
    MaxBytes  : Word;
    BlockSize : Word;
    BytesRet  : Integer;
    InBufPtr  : PAnsiChar;
    OutBufPtr : PAnsiChar;
    PadSize   : Byte;
    IntPad    : Integer;
    RSAKey: PRSA;
begin
    Result := FALSE;
    if NOT Assigned(RSA_public_encrypt) then
        raise Exception.Create('OpenSSL decrecated functions not loaded');
    if not Assigned(PubKey) then
        raise Exception.Create('Public key not assigned');
    if Ics_Ssl_EVP_PKEY_GetType(PubKey) <> EVP_PKEY_RSA then
        raise Exception.Create('No RSA key');
    if (InBuf = nil) or (InLen = 0) then
        raise Exception.Create('Invalid input buffer');
    case Padding of
      rpNoPadding :
          begin
              IntPad := RSA_NO_PADDING;
              PadSize := 0;
          end;
      rpPkcs1Oaep :
          begin
              IntPad := RSA_PKCS1_OAEP_PADDING;
              PadSize := RSA_PKCS1_OAEP_PADDING_SIZE;
          end;
      else
        IntPad := RSA_PKCS1_PADDING;
        PadSize := RSA_PKCS1_PADDING_SIZE;
    end;
    BlockSize := EVP_PKEY_get_size(PubKey);
    MaxBytes := BlockSize - PadSize;
  // Calculate the required result buffer size
    if InLen <= MaxBytes then
        BytesRet := BlockSize
    else
        BytesRet := (InLen div MaxBytes + 1) * BlockSize;
    if (OutLen = 0) or (OutBuf = nil) or
       (Integer(OutLen) < BytesRet) then begin
       { Return required size and exit }
        OutLen := BytesRet;
        Exit; //***
    end;
    InBufPtr  := InBuf;
    OutBufPtr := OutBuf;
    OutLen   := 0;
    RSAKey := EVP_PKEY_get1_RSA(PubKey);   { V9.5 was Ics_Ssl_EVP_PKEY_GetKey that does not like modern keys }
    repeat
        if InLen > MaxBytes then
            Bytes := MaxBytes
        else
            Bytes := InLen;
        if Bytes > 0 then begin
            BytesRet := RSA_public_encrypt(Bytes, InBufPtr, OutBufPtr, RSAKey, IntPad);
            if BytesRet <> BlockSize then
            begin
                if BytesRet = -1 then
                    RaiseLastOpenSslError(Exception, TRUE, 'Function RSA_public_encrypt:')
                else
                    raise Exception.Create('f_RSA_public_encrypt: Ciphertext must match length of key');
            end;
            Dec(InLen, Bytes);
            Inc(InBufPtr, Bytes);
            Inc(OutBufPtr, BytesRet);
            Inc(OutLen, BytesRet);
        end;
    until InLen = 0;
    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function DecryptPrivateRSA(
    PrivKey     : PEVP_PKEY;
    InBuf       : Pointer;
    InLen       : Cardinal;
    OutBuf      : Pointer;
    var OutLen  : Cardinal;
    Padding     : TRsaPadding): Boolean;
var
    Bytes     : Word;
    BlockSize : Word;
    BytesRet  : Integer;
    InBufPtr  : PAnsiChar;
    OutBufPtr : PAnsiChar;
    IntPad    : Integer;
    RSAKey: PRSA;
begin
    Result := FALSE;
  {  if not LibeayExLoaded then
        LoadLibeayEx;    }
    if PrivKey = nil then
        raise Exception.Create('Private key not loaded');
    if Ics_Ssl_EVP_PKEY_GetType(PrivKey) <> EVP_PKEY_RSA then
        raise Exception.Create('No RSA key');
    if (InBuf = nil) or (InLen = 0) then
        raise Exception.Create('Invalid input buffer');
    if (OutLen = 0) or (OutBuf = nil) or
       (InLen > OutLen) then begin
       { Return required size and exit }
        OutLen := InLen;
        Exit; //***
    end;
    case Padding of
      rpNoPadding : IntPad := RSA_NO_PADDING;
      rpPkcs1Oaep : IntPad := RSA_PKCS1_OAEP_PADDING;
      else
        IntPad := RSA_PKCS1_PADDING;
    end;
    Blocksize := EVP_PKEY_get_size(PrivKey);
    OutLen    := 0;
    InBufPtr  := InBuf;
    OutBufPtr := OutBuf;
    RSAKey := EVP_PKEY_get1_RSA(PrivKey);   { V9.5 was Ics_Ssl_EVP_PKEY_GetKey that does not like modern keys }
    repeat
        if InLen > BlockSize then
            Bytes := BlockSize
        else
            Bytes := InLen;
        if Bytes > 0 then begin
            BytesRet := RSA_private_decrypt(Bytes, InBufPtr, OutBufPtr, RSAKey, IntPad);
            if BytesRet = -1 then
                RaiseLastOpenSslError(Exception, TRUE, 'Function RSA_private_decrypt:');
            Dec(InLen, Bytes);
            Inc(InBufPtr, Bytes);
            Inc(OutBufPtr, BytesRet);
            Inc(OutLen, BytesRet);
        end;
    until InLen = 0;
    Result := TRUE;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Takes plain text, returns an encrypted and base64 encoded string }
function StrEncRsa(
    PubKey  : PEVP_PKEY;
    const S : AnsiString;
    B64     : Boolean;
    Padding : TRsaPadding = rpPkcs1): AnsiString;
var
    Len : Cardinal;
begin
    { First call is to get return buffer size }
    EncryptPublicRSA(PubKey, PAnsiChar(S), Length(S), nil, Len, Padding);
    SetLength(Result, Len);
    if EncryptPublicRSA(PubKey, PAnsiChar(S), Length(S), PAnsiChar(Result), Len, Padding) then
    begin
        if B64 then
            Result := IcsBase64EncodeA(Result);     { V9.4 }
    end
    else
        SetLength(Result, 0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Takes an encryted and base64 encoded string, returns plain text }
function StrDecRsa(
    PrivKey : PEVP_PKEY;
    S       : AnsiString;
    B64     : Boolean;
    Padding : TRsaPadding = rpPkcs1): AnsiString;
var
    Len : Cardinal;
begin
    if B64 then
        S := IcsBase64DecodeA(S);         { V9.4 }
    Len := Length(S);
    SetLength(Result, Len);
    if DecryptPrivateRSA(PrivKey, PAnsiChar(S), Len, PAnsiChar(Result), Len, Padding) then
        { Adjust string length! }
        SetLength(Result, Len)
    else
        SetLength(Result, 0);
end;
{$ENDIF OpenSSL_Deprecated}   { V9.5 }


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure CiphFinalize(var CiphCtx: TCiphContext);
begin
    if Assigned(CiphCtx.Ctx) then begin
   //    EVP_CIPHER_CTX_cleanup(CiphCtx.Ctx);     { V8.66 }
        EVP_CIPHER_CTX_free(CiphCtx.Ctx);
    end;
    FillChar(CiphCtx, SizeOf(CiphCtx), #0);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure CalcMD5(
    Buffer: Pointer;
    BufSize: Integer;
    MD5Digest : PMD5Digest);
var
    I          : Integer;
    MD5Context : TMD5Context;
begin
    for I := 0 to 15 do
        MD5Digest^[I] := I + 1;
    MD5Init(MD5Context);
    MD5UpdateBuffer(MD5Context, Buffer, BufSize);
    MD5Final(MD5Digest^, MD5Context);
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure CiphPasswordToKey(
    InBuf       : AnsiString;
    Salt        : TCipherSalt;
    Count       : Integer;
    var Key     : TCipherKey;
    var KeyLen  : Integer;
    var IV      : TIVector;
    var IVLen   : Integer);
var
    I, nKey, nIV : Integer;
    MD5Digest  : TMD5Digest;
    MD5Context : TMD5Context;
    AddDigest  : Boolean;
begin
    FillChar(Key, SizeOf(TCipherKey), #0);
    FillChar(IV, SizeOf(TIVector), #0);
    if (KeyLen = 0) or (Length(InBuf)= 0) then Exit;
    if KeyLen > SizeOf(TCipherKey) then
        KeyLen := SizeOf(TCipherKey);
    nKey := 0;
    nIV  := 0;
    AddDigest := False;
    for I := 0 to 15 do
        MD5Digest[I] := I + 1;
    while True do
    begin
       MD5Init(MD5Context);
       if AddDigest then
          MD5UpdateBuffer(MD5Context, @MD5Digest[0], SizeOf(MD5Digest))
       else
          AddDigest := TRUE;
       MD5UpdateBuffer(MD5Context, @InBuf[1], Length(InBuf));
       if Length(Salt) > 0 then
            MD5UpdateBuffer(MD5Context, @Salt[1], Length(Salt));
       MD5Final(MD5Digest, MD5Context);
       for I := 1 to Count do begin
          MD5Init(MD5Context);
          MD5UpdateBuffer(MD5Context, @MD5Digest[0], SizeOf(MD5Digest));
          MD5Final(MD5Digest, MD5Context);
       end;
       I := 0;
       if nKey <= KeyLen then
       begin
           while True do
           begin
              if (nKey > KeyLen) or (I > SizeOf(MD5Digest)) then
                  Break;
              Key[nKey] := MD5Digest[I];
              Inc(nkey);
              Inc(I);
           end;
       end;
       if nIV <= IVLen then
       begin
           while True do
           begin
              if (nIV > IVLen) or (I > SizeOf(MD5Digest)) then
                  Break;
              IV[nIV] := MD5Digest[I];
              Inc(nIV);
              Inc(I);
           end;
       end;
       if (nKey > KeyLen) and (nIV > IVLen) then Break;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure CiphInitialize(
    var CiphCtx : TCiphContext;
    const Pwd   : AnsiString;
    Key         : PCipherKey; // if not nil Pwd is ignored and the user is responsible to provide a valid Key and IV
    IVector     : PIVector;
    CipherType  : TCipherType;
    KeyLen      : TCipherKeyLen;
    Enc         : Boolean);
var
    SetKeySize  : Integer;
    //I           : Integer;
    PIV         : Pointer;
    KLen, IVLen : Integer;
begin
 {   if not LibeayExLoaded then
        LoadLibeayEx;   }
    SetKeySize := 0;
    KLen := 0;
    CiphFinalize(CiphCtx);
    CiphCtx.Encrypt := Enc;
    case CipherType of
        ctBfCbc, {ctBfCfb64,} ctBfOfb, ctBfEcb :
          { Blowfish keysize 32-448 bits in steps of 8 bits, default 128 bits }
            begin
                CiphCtx.BlockSize := BF_BLOCK_SIZE;
                IVLen := SizeOf(TIVector);
                case KeyLen of
                  cklDefault, ckl128bit : KLen := 16;
                  ckl64bit  : begin Klen := 8; SetKeySize := KLen; end;
                  ckl256bit : begin Klen := EVP_MAX_KEY_LENGTH; SetKeySize := KLen; end;
                end;
                if CipherType = ctBfCbc then
                    CiphCtx.Cipher := EVP_bf_cbc
                else if CipherType = ctBfOfb then
                    CiphCtx.Cipher := EVP_bf_ofb
                else begin
                    CiphCtx.Cipher := EVP_bf_ecb;
                    IVLen := 0;
                end;
            end;
        else
            raise Exception.Create('Not implemented');
    end;
    { Make the key and IV based on password, this is simple, not compatible }
    { with any standards. }
    if Key = nil then begin
        CalcMD5(@Pwd[1], Length(Pwd), @CiphCtx.Key[0]);     //128-bit key
        if KLen + IVLen > 16 then
            CalcMD5(@CiphCtx.Key[0], 16, @CiphCtx.Key[16]); //256-bit key
        if KLen + IVLen > 32 then
            CalcMD5(@CiphCtx.Key[0], 32, @CiphCtx.Key[32]); //384-bit key
        {if KeyLen + CiphCtx.IVLen > 48 then
            CalcMD5(@CiphCtx.Key[0], 48, @CiphCtx.Key[48]); //512-bit key}
    end
    else
        CiphCtx.Key := Key^;
    if IVLen > 0 then begin
        if IVector = nil then
            Move(CiphCtx.Key[KLen], CiphCtx.IV[0], SizeOf(TIVector))
        else
            Move(IVector^[0], CiphCtx.IV[0], SizeOf(TIVector));
        PIV := @CiphCtx.IV[0];
    end
    else
        PIV := nil;

    CiphCtx.Ctx := EVP_CIPHER_CTX_new;
    try
        EVP_CIPHER_CTX_reset(CiphCtx.Ctx);
        if SetKeySize > 0 then begin
            if EVP_CipherInit_ex(CiphCtx.Ctx, CiphCtx.Cipher, nil, nil, nil, Ord(Enc)) = 0 then          { V8.66 }
                RaiseLastOpenSslError(Exception, TRUE, 'Function EVP_CipherInit_ex:');
            EVP_CIPHER_CTX_set_key_length(CiphCtx.Ctx, SetKeySize);
        end;
        if SetKeySize > 0 then begin
            if EVP_CipherInit_ex(CiphCtx.Ctx, nil, nil, @CiphCtx.key[0], PIV, Ord(Enc)) = 0 then          { V8.66 }
                RaiseLastOpenSslError(Exception, TRUE,  'Function EVP_CipherInit_ex:');
        end
        else begin
            if EVP_CipherInit_ex(CiphCtx.Ctx, CiphCtx.Cipher, nil, @CiphCtx.key[0], PIV, Ord(Enc)) = 0 then     { V8.66 }
                RaiseLastOpenSslError(Exception, TRUE, 'Function EVP_CipherInit_ex:');
        end;
    except
        CiphFinalize(CiphCtx);
        raise;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure CiphSetIVector(
    var CiphCtx : TCiphContext;
    IVector     : PIVector);
var
    PIV : Pointer;
begin
    if not Assigned(CiphCtx.Ctx) then
        raise Exception.Create('Cipher context not initialized');
    if IVector = nil then begin
        FillChar(CiphCtx.IV, SizeOf(TIVector), #0);
        PIV := nil;
    end
    else begin
        CiphCtx.IV := IVector^;
        PIV := @CiphCtx.IV[0];
    end;
    if EVP_CipherInit_ex(CiphCtx.Ctx, nil, nil, nil, PIV, Ord(CiphCtx.Encrypt)) = 0 then    { V8.66 }
        RaiseLastOpenSslError(Exception, TRUE, 'Function EVP_CipherInit_ex:');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure CiphUpdate(
    const InBuf;
    InLen : Integer;
    const OutBuf;
    var OutLen : Integer;
    CiphCtx : TCiphContext);
begin
    if not Assigned(CiphCtx.Ctx) then
        raise Exception.Create('Cipher context not initialized');
    if EVP_CipherUpdate(CiphCtx.Ctx, PAnsiChar(@OutBuf), @OutLen, PAnsiChar(@InBuf), InLen) = 0 then    { V8.66 }
        RaiseLastOpenSslError(Exception, TRUE,  'Function EVP_CipherUpdate:');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure CiphFinal(
    const OutBuf;
    var OutLen : Integer;
    CiphCtx : TCiphContext);
begin
    if not Assigned(CiphCtx.Ctx) then
        raise Exception.Create('Cipher context not initialized');
    if EVP_CipherFinal_ex(CiphCtx.Ctx, PAnsiChar(@OutBuf), @OutLen) = 0 then   { V8.66 }
        RaiseLastOpenSslError(Exception, TRUE, 'Function EVP_CipherFinal_ex:');
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ Takes plain text, returns an encrypted string, optionally base64 encoded }
function StrEncBf(
    const S   : AnsiString;
    const Pwd : AnsiString;
    IV        : PIVector;
    KeyLen    : TCipherKeyLen;
    B64       : Boolean): AnsiString;
var
    Len, TmpLen : Integer;
    CiphCtx : TCiphContext;
begin
    FillChar(CiphCtx, SizeOf(CiphCtx), #0);
    CiphInitialize(CiphCtx, Pwd, nil, IV, ctBfCbc, KeyLen, True);
    try
        Len := Length(S);
        SetLength(Result, Len + CiphCtx.BlockSize);
        CiphUpdate(S[1], Length(S), Result[1], Len, CiphCtx);
        CiphFinal(Result[Len + 1], TmpLen, CiphCtx);
        Inc(Len, TmpLen);
        SetLength(Result, Len);
    finally
        CiphFinalize(CiphCtx);
    end;
    if B64 then
         Result := IcsBase64EncodeA(Result);    { V9.4 }
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
function StrDecBf(
    S         : AnsiString;
    const Pwd : AnsiString;
    IV        : PIVector;
    KeyLen    : TCipherKeyLen;
    B64       : Boolean): AnsiString;
var
    Len, TmpLen : Integer;
    CiphCtx : TCiphContext;
begin
    FillChar(CiphCtx, SizeOf(CiphCtx), #0);
    CiphInitialize(CiphCtx, Pwd, nil, IV, ctBfCbc, KeyLen, False);
    try
        if B64 then
            S := IcsBase64DecodeA(S);    { V9.4 }
        Len := Length(S);
        SetLength(Result, Len + CiphCtx.BlockSize);
        CiphUpdate(S[1], Length(S), Result[1], Len, CiphCtx);
        CiphFinal(Result[Len + 1], TmpLen, CiphCtx);
        Inc(Len, TmpLen);
        SetLength(Result, Len);
    finally
        CiphFinalize(CiphCtx);
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure StreamEncrypt(
    SrcStream  : TStream;
    DestStream : TStream;
    StrBlkSize : Integer;
    CiphCtx    : TCiphContext;
    RandomIV   : Boolean);
var
    Bytes, RetLen, TmpLen : Integer;
    Len : Int64;
    InBuf : array of Byte;
    OutBuf : array of Byte;
    IV : TIVector;
begin
    if RandomIV then begin
        RAND_bytes(@IV[0], SizeOf(TIVector));
        CiphSetIVector(CiphCtx, @IV);
    end;
    if StrBlkSize < 1024 then StrBlkSize := 1024;
    SetLength(InBuf, StrBlkSize);
    SetLength(OutBuf, StrBlkSize + CiphCtx.BlockSize); // Room for padding
    Len := SrcStream.Size;
    SrcStream.Position  := 0;
    DestStream.Position := 0;
    { The IV must be known to decrypt, it may be public.   }
    { Without a random IV we always get the same cipher    }
    { text when using both same key and data.              }
    { http://en.wikipedia.org/wiki/Block_cipher_modes_of_operation }
    if RandomIV then // prepend the Initialization Vector data
        DestStream.Write(IV[0], SizeOf(TIVector));
    TmpLen := 0;
    RetLen := TmpLen;
    while True do begin
        Bytes := SrcStream.Read(InBuf[0], StrBlkSize);
        if Bytes > 0 then begin
            Dec(Len, Bytes);
            CiphUpdate(InBuf[0], Bytes, OutBuf[0], RetLen, CiphCtx);
            if Len <= 0 then begin
                CiphFinal(OutBuf[RetLen], TmpLen, CiphCtx);
                Inc(RetLen, TmpLen);
            end;
            if RetLen <> 0 then
                DestStream.Write(OutBuf[0], RetLen);
        end
        else
            Break;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure StreamEncrypt(
    SrcStream  : TStream;
    DestStream : TStream;
    StrBlkSize : Integer;
    CiphCtx    : TCiphContext;
    RandomIV   : Boolean;
    Obj        : TObject;
    ProgressCallback : TCryptProgress);
var
    Bytes, RetLen, TmpLen : Integer;
    Len : Int64;
    InBuf : array of Byte;
    OutBuf : array of Byte;
    IV : TIVector;
    Cancel: Boolean;
begin
    Cancel := FALSE;
    if RandomIV then begin
        RAND_bytes(@IV[0], SizeOf(TIVector));
        CiphSetIVector(CiphCtx, @IV);
    end;
    if StrBlkSize < 1024 then StrBlkSize := 1024;
    SetLength(InBuf, StrBlkSize);
    SetLength(OutBuf, StrBlkSize + CiphCtx.BlockSize); // Room for padding
    Len := SrcStream.Size;
    SrcStream.Position  := 0;
    DestStream.Position := 0;
    { The IV must be known to decrypt, it may be public.   }
    { Without a random IV we always get the same cipher    }
    { text when using both same key and data.              }
    { http://en.wikipedia.org/wiki/Block_cipher_modes_of_operation }
    if RandomIV then// prepend the Initialization Vector data
        DestStream.Write(IV[0], SizeOf(TIVector));
    TmpLen := 0;
    RetLen := TmpLen;
    while True do begin
        Bytes := SrcStream.Read(InBuf[0], StrBlkSize);
        if Bytes > 0 then begin
            Dec(Len, Bytes);
            CiphUpdate(InBuf[0], Bytes, OutBuf[0], RetLen, CiphCtx);
            if Len <= 0 then begin
                CiphFinal(OutBuf[RetLen], TmpLen, CiphCtx);
                Inc(RetLen, TmpLen);
            end;
            if RetLen <> 0 then begin
                DestStream.Write(OutBuf[0], RetLen);
                if Assigned(ProgressCallback) then begin
                    ProgressCallback(Obj, SrcStream.Position, Cancel);
                    if Cancel then
                        Break;
                end;
            end;
        end
        else
            Break;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure StreamDecrypt(
    SrcStream  : TStream;
    DestStream : TStream;
    StrBlkSize : Integer;
    CiphCtx    : TCiphContext;
    RandomIV   : Boolean);
var
    Bytes, RetLen, TmpLen : Integer;
    Len : Int64;
    InBuf : array of Byte;
    OutBuf : array of Byte;
    IV : TIVector;
begin
    SrcStream.Position := 0;
    if RandomIV then begin
        SrcStream.Read(IV[0], SizeOf(TIVector));
        CiphSetIVector(CiphCtx, @IV);
    end;
    if StrBlkSize < 1024 then StrBlkSize := 1024;
    SetLength(InBuf, StrBlkSize);
    SetLength(OutBuf, StrBlkSize + CiphCtx.BlockSize);
    Len := SrcStream.Size;
    DestStream.Position := 0;
    TmpLen := 0;
    RetLen := TmpLen;
    while True do begin
        Bytes := SrcStream.Read(InBuf[0], StrBlkSize);
        if Bytes > 0 then begin
            Dec(Len, Bytes);
            CiphUpdate(InBuf[0], Bytes, OutBuf[0], RetLen, CiphCtx);
            if Len <= 0 then begin
                CiphFinal(OutBuf[RetLen], TmpLen, CiphCtx);
                Inc(RetLen, TmpLen);
            end;
            if RetLen <> 0 then
                DestStream.Write(OutBuf[0], RetLen);
        end
        else
            Break;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
procedure StreamDecrypt(
    SrcStream  : TStream;
    DestStream : TStream;
    StrBlkSize : Integer;
    CiphCtx    : TCiphContext;
    RandomIV   : Boolean;
    Obj        : TObject;
    ProgressCallback : TCryptProgress);
var
    Bytes, RetLen, TmpLen : Integer;
    Len : Int64;
    InBuf : array of Byte;
    OutBuf : array of Byte;
    IV : TIVector;
    Cancel: Boolean;
begin
    Cancel := FALSE;
    SrcStream.Position := 0;
    if RandomIV then begin
        SrcStream.Read(IV[0], SizeOf(TIVector));
        CiphSetIVector(CiphCtx, @IV);
    end;
    if StrBlkSize < 1024 then StrBlkSize := 1024;
    SetLength(InBuf, StrBlkSize);
    SetLength(OutBuf, StrBlkSize + CiphCtx.BlockSize);
    Len := SrcStream.Size;
    DestStream.Position := 0;
    TmpLen := 0;
    RetLen := TmpLen;
    while True do begin
        Bytes := SrcStream.Read(InBuf[0], StrBlkSize);
        if Bytes > 0 then begin
            Dec(Len, Bytes);
            CiphUpdate(InBuf[0], Bytes, OutBuf[0], RetLen, CiphCtx);
            if Len <= 0 then begin
                CiphFinal(OutBuf[RetLen], TmpLen, CiphCtx);
                Inc(RetLen, TmpLen);
            end;
            if RetLen <> 0 then begin
                DestStream.Write(OutBuf[0], RetLen);
                if Assigned(ProgressCallback) then begin
                    ProgressCallback(Obj, SrcStream.Position, Cancel);
                    if Cancel then
                        Break;
                end;
            end;
        end
        else
            Break;
    end;
end;


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{$IFDEF OpenSSL_Deprecated}  { V9.5 }
procedure CreateRsaKeyPair(const PubFName, PrivFName: String; Bits: Integer);   { V8.35 }
var
    Bne       : PBIGNUM;
    Rsa       : PRSA;
    PubBIO, PrivBio : PBIO;
    Ret       : Integer;
begin
    if NOT ICS_RAND_INIT_DONE then IcsRandPoll;
    PubBIO := nil;
    PrivBIO := nil;
    Rsa := nil;
  { generate fixed odd number exponent }
    Bne := BN_new;
    Ret := BN_set_word(Bne, RSA_F4);
    if Ret = 0 then
        raise Exception.Create('Failed to create exponent');
    try

      { generate RSA key paid }
        Rsa := RSA_new;
        Ret := RSA_generate_key_ex (Rsa, Bits, Bne, nil);
        if (Ret = 0) or (not Assigned(Rsa)) then
            raise Exception.Create('Failed to generate rsa key');

      { save public key file }
        PubBIO := BIO_new_file(PAnsiChar(StringToUtf8(PubFname)), PAnsiChar('w+'));
        Ret := PEM_write_bio_RSAPublicKey (PubBIO, Rsa);
        if Ret = 0 then
            raise Exception.Create('Failed to save public key file: ' + PubFname);

       { save private key file }
        PrivBIO := BIO_new_file(PAnsiChar(StringToUtf8(PrivFname)), PAnsiChar('w+'));
        Ret := PEM_write_bio_RSAPrivateKey (PrivBIO, Rsa, nil, nil, 0, nil, nil);
        if Ret = 0 then
            raise Exception.Create('Failed to save private key file: ' + PrivFname);

    finally
        if Assigned(Bne) then
            BN_free(Bne);
        if Assigned(Rsa) then
            RSA_free(Rsa);
        if Assigned(PubBio) then
            BIO_free(PubBio);
        if Assigned(PrivBio) then
            BIO_free(PrivBio);
    end;
end;
{$ENDIF OpenSSL_Deprecated}   { V9.5 }


{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}

{$ENDIF}  { USE_SSL }


end.
