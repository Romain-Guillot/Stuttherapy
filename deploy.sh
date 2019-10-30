echo "---THIS SCRIPT WILL CREATE APP BUNDLE---"
echo "> suppress old files"
rm -f build/app/outputs/bundle/release/app.aab
rm -f build/app/outputs/bundle/release/stuttherapy.apks
echo "done."
echo "> build application bundle"
flutter build appbundle && 
java -jar bundletool.jar build-apks --bundle=build/app/outputs/bundle/release/app.aab --output build/app/outputs/bundle/release/stuttherapy.apks --ks=keystore.jks --ks-pass=file:keystore.pwd --ks-key-alias=key --key-pass=file:keystore.pwd
echo "done."
echo "Application bundle and apks not avalable in build/app/outputs/bundle/release directory (if previous commands do not raise errors...)."
