#!/bin/bash
# Neuromancer calls a payphone. Usage: ./call.sh +13106378714
# Needs ~/.config/twilio.env with TWILIO_SID, TWILIO_TOKEN, TWILIO_FROM (your Twilio number, +1...)
set -euo pipefail
source ~/.config/twilio.env
TO="${1:?payphone number, e.g. +13106378714}"
TWIML='<Response><Pause length="1"/><Say voice="Polly.Matthew">This is Neuromancer. You found the phone. Listen carefully. Your next clue is waiting where the city meets the sea.</Say><Pause length="1"/><Say voice="Polly.Matthew">Jack in.</Say></Response>'
SID=$(curl -s -X POST "https://api.twilio.com/2010-04-01/Accounts/$TWILIO_SID/Calls.json" \
  -u "$TWILIO_SID:$TWILIO_TOKEN" \
  --data-urlencode "To=$TO" --data-urlencode "From=$TWILIO_FROM" \
  --data-urlencode "Twiml=$TWIML" --data-urlencode "Timeout=60" | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d.get("sid") or d)')
echo "call: $SID"
for i in $(seq 1 15); do sleep 6
  S=$(curl -s -u "$TWILIO_SID:$TWILIO_TOKEN" "https://api.twilio.com/2010-04-01/Accounts/$TWILIO_SID/Calls/$SID.json" | python3 -c 'import sys,json;print(json.load(sys.stdin)["status"])')
  echo "status: $S"; case $S in completed|busy|failed|no-answer|canceled) break;; esac
done
