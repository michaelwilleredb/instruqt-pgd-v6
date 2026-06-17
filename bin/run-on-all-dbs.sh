# 1. Define your servers
SERVERS=("db-1" "db-2" "db-3")

# 2. Run the command in parallel
printf "%s\n" "${SERVERS[@]}" | xargs -I {} -P 3 ssh -o "StrictHostKeyChecking=no" {} "$1"

# 3. Check if everything succeeded
if [ $? -eq 0 ]; then
    echo "🎉 Success! All servers completed without errors."
else
    echo "❌ Error: One or more servers failed."
fi