# Komponenty

## Automatizační kód

Automatizační nástroj je uchován na Githubu v repozitáři [pywb](https://github.com/WebarchivCZ/pywb), vlastněným organizací [WebarchivCZ](https://github.com/WebarchivCZ).

## Webrecorder pywb toolkit

### Base images

Služba pywb je provozovaná z docker image vytvořeném tvůrcem pywb [Ilya Kreymer](https://github.com/ikreymer). Všechny dostupné tagy obrazu jsou zveřejněné na [Dockerhub](https://hub.docker.com/r/webrecorder/pywb/tags). V okamžiku psaního tohoto dokumentu byla nejnovější verze pywb 2.7.4.

## Dokumentace

### Material for MkDocs

[Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) je framework nad [MkDocs](https://www.mkdocs.org) který z Markdown dokumentace vytváří statickou stránku. Dokumentace je uchována ve složce
`./docs`.

Příkaz `./mkdocs.sh` spustí lokální dokumentaci na adrese http://0.0.0.0:8000/

### Github Pages

[Github Pages](https://pages.github.com/) umožňuje hostování statickým webů z githubu. Včetně právě čtené [Dokumentace](https://webarchivcz.github.io/pywb/).

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

## Traefik

[Traefik](https://doc.traefik.io/traefik/) směřuje požadavky vůči serveru na konkrétní služby jako je např. pywb.

- [Github Pages](https://pages.github.com/)
