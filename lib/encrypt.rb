# ENCRYPT

require 'openssl'
require 'base64'

public_key_file = '/Users/tganzar/.ssh/id_rsa.pem.pub';
string = 'Hello World!';

public_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))
encrypted_string = Base64.encode64(public_key.public_encrypt(string))