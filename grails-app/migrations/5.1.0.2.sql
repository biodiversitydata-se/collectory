UPDATE data_provider SET gbif_country_to_attribute = '' WHERE gbif_country_to_attribute IS NULL;
ALTER TABLE data_provider MODIFY gbif_country_to_attribute varchar(3) NOT NULL;

UPDATE institution SET gbif_country_to_attribute = '' WHERE gbif_country_to_attribute IS NULL;
ALTER TABLE institution MODIFY gbif_country_to_attribute varchar(3) NOT NULL;

