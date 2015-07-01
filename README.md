ssh-keygen -f ~/.ssh/id_rsa.pub -e -t PKCS8 > ~/.ssh/id_rsa.pem.pub
openssl rsautl -encrypt -pubin -inkey id_rsa.pem.pub -ssl -in myMessage.txt -out myEncryptedMessage.txt