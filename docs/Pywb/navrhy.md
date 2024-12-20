# Změnové návrhy pro rok 2025

## Nová abstrakce pro tématické kolekci

Tématická sklizeň je sada sklizní, která vytváří jednu kolekci.

### Současný stav

```
- /mnt/archive
    - /topics
        # Tématická sklizeň 2024-CUNI
        - /mnt/archive/24/topics/Topics-2024-01-T-CUNI-MagistratHlMPrahy-NarArchiv-MilanKundera-UtokNaFilozofickeFakulteUK
        - /mnt/archive/24/topics/Topics-2024-02-T-CUNI-MagistratHlMPrahy-NarArchiv-UtokNaFilozofickeFakulteUK-DezinfoWeby-10WebuProVecnost
        - /mnt/archive/24/topics/Topics-2024-03-T-CUNI-MagistratHlMPrahy-NarArchiv
        - /mnt/archive/24/topics/Topics-2024-04-T-CUNI-MagistratHlMPrahy-NarArchiv-BedrichSmetana-VolbyDoEU2024
        - /mnt/archive/24/topics/Topics-2024-04-T-CUNI-MagistratHlMPrahy-NarArchiv-BedrichSmetana-VolbyDoEU2024-2
        - /mnt/archive/24/topics/Topics-2024-04-T-CUNI-MagistratHlMPrahy-NarArchiv-BedrichSmetana-VolbyDoEU2024-3
        - /mnt/archive/24/topics/Topics-2024-05-CUNI-MagistratHlMPrahy-NarArchiv-ErotAPorno-Rajce-SlevyLetaky
        - /mnt/archive/24/topics/Topics-2024-05-CUNI-MagistratHlMPrahy-NarArchiv-ErotAPorno-Rajce-SlevyLetaky-2
        - /mnt/archive/24/topics/Topics-2024-06-CUNI-MagistratHlMPrahy-NarArchiv-Webzdarma-RizikoveWeby
        - /mnt/archive/24/topics/Topics-2024-06-CUNI-MagistratHlMPrahy-NarArchiv-Webzdarma-RizikoveWeby-2

        # Tématická sklizeň 2024-WikiSources
        - /mnt/archive/24/topics/Topics-2024-01-T-WikiSources
        - /mnt/archive/24/topics/Topics-2024-01-T-WikiSources-- 2

        # Tématická sklizeň Covid19-ValkaNaUkrajine
        - /mnt/archive/24/topics/Topics-2024-02-T-Covid19-ValkaNaUkrajine
        - /mnt/archive/24/topics/Topics-2024-03-T-Covid19-ValkaNaUkrajine
        - /mnt/archive/24/topics/Topics-2024-04-T-Covid19-ValkaNaUkrajine
        - /mnt/archive/24/topics/Topics-2024-05-T-Covid19-ValkaNaUkrajine
        - /mnt/archive/24/topics/Topics-2024-06-T-Covid19-ValkaNaUkrajine

```

### Navrhovaný stav A

#### Souborý Systém
```yaml
/mnt/index/collections:
  - "2024-06-VolbyDoEU"
    - "archive/archive-paths.txt"
    - "index/index.cdxj"
  - 2024-Covid19-ValkaNaUkrajine
    - "archive/archive-paths.txt"
    - "index/index.cdxj"
  - 2024-CUNI
    - "archive/archive-paths.txt"
    - "index/index.cdxj"
  - 2024-WikiSources
    - "archive/archive-paths.txt"
    - "index/index.cdxj"
```
#### Docker-compose
```yaml
volumes:
  - /mnt/index/collections:/webarchive/collections
  - /mnt/archive:/mnt/archive:ro
```
#### Pohled z kontejneru
```yaml
/webarchive/collections:
  - "2024-06-VolbyDoEU"
    - "archive/archive-paths.txt"
    - "index/index.cdxj"
  - 2024-Covid19-ValkaNaUkrajine
    - "archive/archive-paths.txt"
    - "index/index.cdxj"
  - 2024-CUNI
    - "archive/archive-paths.txt"
    - "index/index.cdxj"
  - 2024-WikiSources
    - "archive/archive-paths.txt"
    - "index/index.cdxj"

/mnt/archive:
  - "05"
  - "06"
  - "07"
  - "..."
  - "24"

```

#### Obsah archive-paths.txt
```yaml
```

### Navrhovaný stav B

```
- /mnt/archive
  - /topics
    - /CUNI
        - /mnt/archive/24/topics/Topics-2024-01-T-CUNI-MagistratHlMPrahy-NarArchiv-MilanKundera-UtokNaFilozofickeFakulteUK
        - /mnt/archive/24/topics/Topics-2024-02-T-CUNI-MagistratHlMPrahy-NarArchiv-UtokNaFilozofickeFakulteUK-DezinfoWeby-10WebuProVecnost
        - /mnt/archive/24/topics/Topics-2024-03-T-CUNI-MagistratHlMPrahy-NarArchiv
        - /mnt/archive/24/topics/Topics-2024-04-T-CUNI-MagistratHlMPrahy-NarArchiv-BedrichSmetana-VolbyDoEU2024
        - /mnt/archive/24/topics/Topics-2024-04-T-CUNI-MagistratHlMPrahy-NarArchiv-BedrichSmetana-VolbyDoEU2024-2
        - /mnt/archive/24/topics/Topics-2024-04-T-CUNI-MagistratHlMPrahy-NarArchiv-BedrichSmetana-VolbyDoEU2024-3
        - /mnt/archive/24/topics/Topics-2024-05-CUNI-MagistratHlMPrahy-NarArchiv-ErotAPorno-Rajce-SlevyLetaky
        - /mnt/archive/24/topics/Topics-2024-05-CUNI-MagistratHlMPrahy-NarArchiv-ErotAPorno-Rajce-SlevyLetaky-2
        - /mnt/archive/24/topics/Topics-2024-06-CUNI-MagistratHlMPrahy-NarArchiv-Webzdarma-RizikoveWeby
        - /mnt/archive/24/topics/Topics-2024-06-CUNI-MagistratHlMPrahy-NarArchiv-Webzdarma-RizikoveWeby-2
    - /WikiSources
        - /mnt/archive/24/topics/Topics-2024-01-T-WikiSources
        - /mnt/archive/24/topics/Topics-2024-01-T-WikiSources-- 2

    - /Covid19-ValkaNaUkrajine
        - /mnt/archive/24/topics/Topics-2024-02-T-Covid19-ValkaNaUkrajine
        - /mnt/archive/24/topics/Topics-2024-03-T-Covid19-ValkaNaUkrajine
        - /mnt/archive/24/topics/Topics-2024-04-T-Covid19-ValkaNaUkrajine
        - /mnt/archive/24/topics/Topics-2024-05-T-Covid19-ValkaNaUkrajine
        - /mnt/archive/24/topics/Topics-2024-06-T-Covid19-ValkaNaUkrajine

```

### Odůvodnění 2

V současném nastavení je potřeba mapovat tématické sklizně takto:

```
volume_to_collection_mapping:
  # Collections of Topics
  ## 2024-WikiSources
  ### Index
  - /mnt/index/topics/2024-WikiSources/:/webarchive/collections/2024-WikiSources/indexes/
  ### Archives
  - /mnt/archive/24/topics/Topics-2024-01-T-WikiSources:/webarchive/collections/2024-WikiSources/archive/Topics-2024-01-T-WikiSources
  - /mnt/archive/24/topics/Topics-2024-01-T-WikiSources-2:/webarchive/collections/2024-WikiSources/archive/Topics-2024-01-T-WikiSources-2
  - /mnt/archive/23/topics/Topics-2023-12-T-WikiSources:/webarchive/collections/2023-WikiSources/archive/Topics-2023-12-T-WikiSources // tuhle sklizeň jsme si vymyslel pro ilustraci kolekce napříč roky
```

Po změně bude možné mapovat tématické sklizně takto:

```
volume_to_collection_mapping:
  # Collections of Topics
  ## WikiSources
  ### Index
  - /mnt/index/topics/2024-WikiSources/:/webarchive/collections/2024-WikiSources/indexes/
  ### Archives
  - /mnt/archive/24/topics/WikiSources:/webarchive/collections/WikiSources/archive/
  - /mnt/archive/23/topics/WikiSources:/webarchive/collections/WikiSources/archive/ // tuhle sklizeň jsme si vymyslel pro ilustraci kolekce napříč roky

```

Výhody:

- Vše co co je přidáno do existující kolekce, může být reindexováno bez akutalizace kolekce v kódu
- Snadnější a čitelnější mapování kolekcí v Docker-compose
