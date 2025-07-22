#!/bin/bash

echo "Building Mini Apps"
echo "--------------------------------"
echo "Starting build process..."
echo "--------------------------------"

# Run build.sh in mini_app_form
cd mini_app_form
./build.sh
echo "Mini App Form built successfully"

# rename the mpk file to mini_app_form.mpk
mv build/app.mpk build/mini_app_form.mpk
cd ..

echo "Mini App Form mpk file renamed to mini_app_form.mpk"

# Run build.sh in mini_app_practice
cd mini_app_practice
./build.sh
echo "Mini App Practice built successfully"

# rename the mpk file to mini_app_practice.mpk
mv build/app.mpk build/mini_app_practice.mpk
cd ..

echo "Mini App Practice mpk file renamed to mini_app_practice.mpk"

# copy the mpk file to host_app/assets/build/
cp mini_app_form/build/mini_app_form.mpk host_app/assets/build/mini_app_form.mpk
cp mini_app_practice/build/mini_app_practice.mpk host_app/assets/build/mini_app_practice.mpk

echo "MPK files copied to host_app/assets/build/"

echo "--------------------------------"
echo "Build process completed successfully"
echo "--------------------------------"
