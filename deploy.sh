flutter build appbundle && 
java -jar bundletool.jar build-apks --bundle=build/app/outputs/bundle/release/app.aab --output build/app/outputs/bundle/release/stuttherapy.apks --ks=keystore.jks --ks-pass=file:keystore.pwd --ks-key-alias=key --key-pass=file:keystore.pwd
