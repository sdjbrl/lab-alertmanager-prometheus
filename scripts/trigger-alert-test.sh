#!/bin/bash
# trigger-alert-test.sh — Déclenche une alerte ServiceDown pour tester Alertmanager

set -e

echo "=== Test Alertmanager ==="
echo "Arrêt de node-exporter pendant 3 minutes..."
docker compose stop node-exporter

echo "Attente que l'alerte passe en Pending (for: 2m)..."
for i in {1..6}; do
    sleep 30
    STATUS=$(curl -s http://localhost:9090/api/v1/alerts | python3 -c "
import sys, json
data = json.load(sys.stdin)
alerts = [a for a in data.get('data','') or [] if a['labels']['alertname']=='ServiceDown']
print(alerts[0]['state'] if alerts else 'inactive')
" 2>/dev/null || echo "inactive")
    echo "  [${i}/6] ServiceDown : $STATUS"
    if [ "$STATUS" = "firing" ]; then
        echo "✅ Alerte Firing ! Vérifier http://localhost:9093"
        break
    fi
done

echo ""
echo "Redémarrage de node-exporter..."
docker compose start node-exporter
echo "✅ Alerte devrait se résoudre dans 1-2 minutes"
echo "   Vérifier la notification 'resolved' dans Alertmanager ou webhook.site"
