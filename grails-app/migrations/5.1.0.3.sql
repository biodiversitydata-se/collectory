CREATE TABLE `data_hub_external_identifier` (
                                                `data_hub_external_identifiers_id` bigint NOT NULL,
                                                `external_identifier_id` bigint DEFAULT NULL,
                                                KEY `FKirj1ih9m2xspn1aki6xoeavsx` (`external_identifier_id`),
    KEY `FKiwkh0on1fsiy5on971yoi0e0q` (`data_hub_external_identifiers_id`),
    CONSTRAINT `FKirj1ih9m2xspn1aki6xoeavsx` FOREIGN KEY (`external_identifier_id`) REFERENCES `external_identifier` (`id`),
    CONSTRAINT `FKiwkh0on1fsiy5on971yoi0e0q` FOREIGN KEY (`data_hub_external_identifiers_id`) REFERENCES `data_hub` (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `data_hub_external_identifier` (`data_hub_external_identifiers_id`, `external_identifier_id`) select c.id, e.id from external_identifier e inner join data_hub c on e.entity_uid = c.uid;
