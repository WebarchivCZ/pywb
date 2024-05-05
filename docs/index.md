# Webový archiv

Nástroj [Českého Webového archivu Národoní knihovny](https://webarchiv.cz/en/) pro nasazování služby pro zobrazování archivovaných webů dostupný na adrese [pywb.webarchiv.cz](https://pywb.webarchiv.cz).

## Automatizační kód

Automatizační nástroj je uchován na Githubu v repozitáři [pywb](https://github.com/WebarchivCZ/pywb), vlastněným organizací [WebarchivCZ](https://github.com/WebarchivCZ).

## Traefik

[Traefik](https://doc.traefik.io/traefik/) směřuje požadavky vůči serveru na konkrétní služby jako je např. pywb.

- [Github Pages](https://pages.github.com/)

## pywb

[Pywb](https://pywb.readthedocs.io/en/latest/) je jádrem celého řešení. Základní funkcí je vyhledávání URL v archivu, zobrazování webových stránek z digitálních objektů uložených ve WARC a ARC a kontrola přístup ke kolekci.

### Base images

Služba pywb je provozovaná z docker image vytvořeném tvůrcem pywb [Ilya Kreymer](https://github.com/ikreymer). Všechny dostupné tagy obrazu jsou zveřejněné na [Dockerhub](https://hub.docker.com/r/webrecorder/pywb/tags). V okamžiku psaního tohoto dokumentu byla nejnovější verze pywb 2.7.4.

## Material for MkDocs

[Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) je framework nad [MkDocs](https://www.mkdocs.org) který z Markdown dokumentace vytváří statickou stránku. Dokumentace je uchována ve složce
`./docs`.

Příkaz `./mkdocs.sh` spustí lokální dokumentaci na adrese http://0.0.0.0:8000/

## Github Pages

[Github Pages](https://pages.github.com/) umožňuje hostování statickým webů z githubu. Včetně právě čtené [Dokumentace](https://webarchivcz.github.io/pywb/).

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

# Nasazení

## Pywb & Traefik

Jenkins file instruuje https://jenkins.webarchiv.cz běžící na wa-dev-docker00.

## Infrastruktura

- host: 10.3.0.21
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
