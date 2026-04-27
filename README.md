# lab-alertmanager-prometheus 🔔

**Lab BTS SIO SISR — Supervision et alerting avec Prometheus + Alertmanager**

## Contexte

Ton portfolio montre Prometheus + Grafana **mais sans aucune règle d'alerte définie**. C'est un trou béant : une supervision sans alertes ne sert à rien la nuit quand tout tombe. Ce lab corrige ça.

## Ce que tu vas apprendre

- Écrire des règles d'alerte Prometheus (disk, CPU, service down, RAM)
- Configurer Alertmanager (routing, grouping, inhibition)
- Recevoir des alertes par email et/ou Slack
- Tester le déclenchement des alertes

## Architecture du lab

```
┌─────────────────────────────────────────────────┐
│  Docker Compose (1 machine Linux suffit)        │
│                                                 │
│  ┌──────────────┐    ┌─────────────────────┐   │
│  │  Prometheus  │───▶│    Alertmanager      │   │
│  │  :9090       │    │    :9093            │   │
│  └──────┬───────┘    └──────────┬──────────┘   │
│         │                       │               │
│  ┌──────▼───────┐    ┌──────────▼──────────┐   │
│  │  node-exporter│   │  Email / Slack       │   │
│  │  :9100        │   │  (webhook.site test) │   │
│  └──────────────┘    └─────────────────────┘   │
│                                                 │
│  ┌──────────────┐                               │
│  │   Grafana    │                               │
│  │   :3000      │                               │
│  └──────────────┘                               │
└─────────────────────────────────────────────────┘
```

## Prérequis

- Docker + Docker Compose installés
- Linux ou WSL2

## Démarrage rapide

```bash
git clone https://github.com/sdjbrl/lab-alertmanager-prometheus
cd lab-alertmanager-prometheus

# Copier et adapter la config alertmanager
cp configs/alertmanager.yml.example configs/alertmanager.yml
# Éditer configs/alertmanager.yml → mettre ton email ou webhook Slack

# Lancer la stack
docker compose up -d

# Vérifier
docker compose ps
```

- Prometheus : http://localhost:9090
- Alertmanager : http://localhost:9093  
- Grafana : http://localhost:3000 (admin/admin)

## Structure

```
lab-alertmanager-prometheus/
├── docker-compose.yml
├── configs/
│   ├── prometheus.yml          # Scrape config + règles
│   ├── alert-rules.yml         # Règles d'alerte (disk, CPU, service)
│   ├── alertmanager.yml.example # Template à copier
│   └── grafana-datasource.yml  # Provisioning Grafana auto
├── docs/
│   ├── 01-concepts-alerting.md
│   ├── 02-regles-prometheus.md
│   ├── 03-alertmanager-routing.md
│   ├── 04-tester-alertes.md
│   └── 05-dashboard-grafana.md
└── scripts/
    └── trigger-alert-test.sh   # Simule une alerte pour tester
```

## Parcours recommandé

1. `docs/01-concepts-alerting.md` — Comprendre le pipeline alerte
2. `docs/02-regles-prometheus.md` — Écrire les règles PromQL
3. `docs/03-alertmanager-routing.md` — Router les alertes
4. `docker compose up -d` — Lancer le lab
5. `docs/04-tester-alertes.md` — Déclencher les alertes
6. `docs/05-dashboard-grafana.md` — Visualiser dans Grafana

## Lien avec le portfolio IRIS

Le projet infra-iris utilise Prometheus+Grafana. Ajouter ces règles d'alerte = **compétence C5 (maintenance)** prouvée pour le jury E5.
