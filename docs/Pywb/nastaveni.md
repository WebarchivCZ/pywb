# Nastavení

## Datová Struktura

### Struktura archivu

Sklizně jsou rozdělené do let a jsou v režimu read-only. Vyjímkou je vždy aktuální rok.

> - `05` - Read-only sklizně z roku 2005, navíc obsahuje všechny sklizně před rokem 2005.
> - `06` - Read-only sklizně z roku 2006
> - `23` - Read-only sklizně z roku 2023
> - `24` - Read/Write sklizně z roku 2024 (aktuální rok).

S postupem času přibývali nové typy sklizní a strategie sklízení. Změnil se archviní formát z [ARC](https://archive.org/web/researcher/ArcFileFormat.php) do [WARC](http://bibnum.bnf.fr/WARC/) s přechodem na Heritrix 3. Nyní je na zvážení používání archivního formátu [WACZ](https://specs.webrecorder.net/wacz/1.1.1/).

Typy sklizní jsou popsány na stránkách [českého webového archivu](https://webarchiv.cz/cs/o-webarchivu). Obecně se dá říci, že výběrové sklizně jsou sklizně, u kterých je vyjednáno zpřístupnění archivovaného obsahu veřejnosti a webový archiv je sklízí periodicky. Tématické a celoplošné sklizně obsahují převážně data, k nímž v čase archivace nebylo vyjednáno zpřístupnění veřejnosti, ale mohou se okrajově překývat se zdroji, ke kterým bylo vyjednáno zpřístupnění veřejnosti. V referenčním centru Národní knihovny je dostupný i archivní obsah, který nebyl vyjednán k zveřejnění a který není omezen z jiných důvodů. Takto popsaný režim přístup vychází z české legislativy.

V současné době se archiv obvykle skládá z následujících strategií sklizní. Výběrové sklizně jsou v drtivém případě realizované v rámci sklizní ve složce `serials`, Celoplošné sklizně v rámci složky `totals`. Ostatní sklizně plní primárně Tématické sklině. Koncový uživatel webového archivu neví, v rámci jaké sklízecí strategie a v rámci kterého typu sklizně byla data získána. To je technický údaj, který není dostupný pomocí OpenWayback. V rámci Pywb je určitá šance, tuto informaci zpřístupnit.

#### Výběrové sklizně

- `serials` - Výběrové sklizně.
- `tests` - testovací, technické sklizně na zvážení zda je možné webovou stránku archivovat v dostačující kvalitě.

#### Tématické sklizně

- `topics`- Tématické sklizně
- `continuous` - průběžné sklizně NewsDigest - Tématické sklizně
- `continuous-cov19` - průběžné sklizně k tématu Covid 2019 - Tématické sklizně
- `continuous-ukrainewar` - průběžné sklizně k tématu válka na Ukrajině - Tématické sklizně

#### Celoplošné sklizně

- `totals` - Celoplošné sklizně

#### Individuální sklizně

- `manuals` - ruční sklizně - Tématické sklizně & z malé části výběrové sklizně

### Host

- `/index/` - SSD disk připojený pro rychlou práci s indexem
- `/mnt/archive/` - Obsahuje sklizené archivy pro každý rok. Každý rok je připojený přes NFSv4.

### PyWb docker image

- `/webarchive/config.yaml` - konfigurační soubor
- `/webarchive/collections/` - adresář se všemi namapovaný kolekcemi z `/mnt/archive`

## Webrecorder pywb toolkit

### Automatická indexace

[Oficiální Pywb dokumentace: Dynamic Collections and Automatic Indexing](https://pywb.readthedocs.io/en/latest/manual/usage.html#dynamic-collections-and-automatic-indexing)

[Github Pull Request pro Automatickou Indexace](https://github.com/webrecorder/pywb/commit/733642551da989fdfc227e16d7ab75871060efb7)
