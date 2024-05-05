# Nasazování

## Pywb & Traefik

Jenkins file instruuje https://jenkins.webarchiv.cz běžící na wa-dev-docker00.

## Infrastruktura

### Host

- ip: 10.3.0.21
- user: ansible
- groups: sudo
- Jenkins access via /home/ansible/.ssh/authorized_keys

### PyWb & Traefik

- Spuštění:
  - Test: `/home/ansible/pywb/run-test.sh`
  - Produkce: `/home/ansible/pywb/run-prod.sh`

# Stav

## nyní

pywb: [http://10.3.0.21:443](http://10.3.0.21:443)
traefik dashboard: [http://10.3.0.21](http://10.3.0.21:443)

## plán

pywb: [https://pywb.webarchiv.cz](https://pywb.webarchiv.cz) - veřejný
Traefik dashboard: [https://pywb.webarchiv.cz/traefik/](https://pywb.webarchiv.cz/traefik/) - z knihovny nebo VPN, může být i veřejný
