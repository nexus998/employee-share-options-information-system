# README

Ši sistema yra skirta bakalauro baigiamojo darbo atsiskaitymui.

Sistemos pagrindinis funkcionalumas:
* Darbuotojų opcionų skaičiavimas pagal lanksčias taisykles
* Darbuotojų opcionų sertifikatų generavimas
* Asmeninių opcionų peržiūros portalas

Reikalingos versijos:
- Ruby 2.7.5
- Rails 7.0
- Ubuntu 20.04

# Sistemos paleidimas:

1. Atsisiuntus projektą, reikia paruošt Google Cloud Project projektą ir nustatyti naują OAuth2 Client ID.
2. Gavus Client ir Secret kodus, reikia juos įdėti į `application.yml` failą, kurį reikia sukurti `config/` aplankale.
    `application.yml` pavyzdys:
    `google_client: čia dedamas kliento kodas`
    `google_secret: čia dedamas secret kodas`
3. Turint kodus, per Terminal komandinę eilutę įvesti `rails s`
4. Per naršyklę prisijungti į `localhost:3000`
