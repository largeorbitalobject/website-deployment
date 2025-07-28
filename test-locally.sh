#!/bin/bash

echo "Starting local test server..."
echo "Visit http://localhost:8000 to view your site"
echo "Press Ctrl+C to stop the server"
cd src && python3 -m http.server 8000