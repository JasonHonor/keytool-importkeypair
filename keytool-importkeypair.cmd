#! /bin/bash
#
# This file is part of keytool-importkeypair.
#
# keytool-importkeypair is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# keytool-importkeypair is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with keytool-importkeypair.  If not, see
# <http://www.gnu.org/licenses/>.
#./keytool-importkeypair ./platform.keystore platform.pk8 platform.x509.pem platform pass
# Convert PK8 to PEM KEY
SET DEFAULT_KEYSTORE=$HOME/.keystore
SET keystore=%1
SET pk8=%2
SET cert=%3
SET alias=%4
SET passphrase=%5
SET tmpdir=""
SET key=.\temp-platform.key
SET p12=.\temp-platform.p12

openssl pkcs8 -inform DER -nocrypt -in "%pk8%" -out "%key%"

REM Bundle CERT and KEY
openssl pkcs12 -export -in "%cert%" -inkey "%key%" -out "%p12%" -password pass:"%passphrase%" -name "%alias%"

REM Print cert
openssl x509 -noout -fingerprint -in "%cert%"

REM Import P12 in Keystore
"C:\Program Files\Java\jdk1.8.0_152\bin\keytool.exe" -importkeystore -deststorepass "%passphrase%" -destkeystore "%keystore%" -srckeystore "%p12%" -srcstoretype PKCS12 -srcstorepass "%passphrase%" 

REM Cleanup
cleanup
