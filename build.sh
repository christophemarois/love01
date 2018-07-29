rm -r dist
mkdir -p dist
zip -r dist/love01.love . -x \*.git\* -x \*dist\*
cd dist
curl -L "https://bitbucket.org/rude/love/downloads/love-11.1-macos.zip" -o bin.zip
unzip "bin.zip"
rm "bin.zip"
mv "love.app" "love01.app"
cp "love01.love" "love01.app/Contents/Resources/"
plutil -replace CFBundleIdentifier -string "com.deuxcinqtrois.love01" "love01.app/Contents/Info.plist"
plutil -replace CFBundleName -string "love01" "love01.app/Contents/Info.plist"
plutil -remove UTExportedTypeDeclarations "love01.app/Contents/Info.plist"
zip -9 -r "love01-macos.zip" "love01.app" -y
rm -r "love01.app"