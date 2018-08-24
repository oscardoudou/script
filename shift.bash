for f in ~/Downloads/playground/*; do
	old=$(stat -f %B -t %s "$f")
    new=$(date -r $(($old - 46800)) '+%m/%d/%Y %H:%M:%S')
    SetFile -d "$new" -m "$new" "$f"
done