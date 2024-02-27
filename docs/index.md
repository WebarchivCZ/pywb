# Základní komponenty
- [PyWb](https://pywb.readthedocs.io/en/latest/)
- [Traefik](https://doc.traefik.io/traefik/)
- [MkDocs](https://www.mkdocs.org)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [Github Pages](https://pages.github.com/)

## Github Pages

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

### Lokální dokumentace
Příkaz ```./mkdocs.sh``` spustí lokální dokumentaci na adrese http://0.0.0.0:8000/ 

# Nasazení

## Pywb & Traefik
Jenknins file instruuje https://jenkins.webarchiv.cz běžící na wa-dev-docker00.

## Infrastruktura
 - host: 10.3.0.21
 - groups: sudo
 - Jenkins access via /home/ansible/.ssh/authorized_keys

### PyWb & Traefik
 - Spuštění: 
    - Test: /home/ansible/pywb/run-test.sh
    - Produkce: /home/ansible/pywb/run-test.sh