This repository store certificates for local usage, only in development process.

When you visit local site, chrome complaints about insecure connection, to solve it download root certificate:

https://github.com/systemeio/certificates/blob/main/systeme-ca.pem

Ubuntu:

- And upload it in chrome settings:
- ```Settings -> Security and Privacy -> Security -> Manage certificates -> Authorities```
- Click import button and upload `systeme-ca.pem`
- In opened popup click checkbox `Trust this certificate for identifying websites`

Macos:

- Open the Keychain Access Program on the Mac
- Choose: System chaincase -> System
- File: Import items
- Upload  `systeme-ca.pem`
- Console menu on the certificate -> Get Info -> Trust -> Always trust
