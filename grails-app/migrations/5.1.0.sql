CREATE TABLE `collection_external_identifier` (
    `collection_external_identifiers_id` bigint NOT NULL,
    `external_identifier_id` bigint DEFAULT NULL,
    KEY `FK8k1v2k7qw2k3dyqnhf3xg1i86` (`external_identifier_id`),
    CONSTRAINT `FK8k1v2k7qw2k3dyqnhf3xg1i86` FOREIGN KEY (`external_identifier_id`) REFERENCES `external_identifier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `collection_external_identifier` (`collection_external_identifiers_id`, `external_identifier_id`) select c.id, e.id from external_identifier e inner join collection c on e.entity_uid = c.uid;

CREATE TABLE `data_provider_external_identifier` (
    `data_provider_external_identifiers_id` bigint NOT NULL,
    `external_identifier_id` bigint DEFAULT NULL,
    KEY `FKjxuqgndu3vxuvi9rn4vo93e36` (`external_identifier_id`),
    KEY `FKd92u2i4h2j9i4pqq3dppoatf` (`data_provider_external_identifiers_id`),
    CONSTRAINT `FKd92u2i4h2j9i4pqq3dppoatf` FOREIGN KEY (`data_provider_external_identifiers_id`) REFERENCES `data_provider` (`id`),
    CONSTRAINT `FKjxuqgndu3vxuvi9rn4vo93e36` FOREIGN KEY (`external_identifier_id`) REFERENCES `external_identifier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `data_provider_external_identifier` (`data_provider_external_identifiers_id`, `external_identifier_id`) select c.id, e.id from external_identifier e inner join data_provider c on e.entity_uid = c.uid;

CREATE TABLE `data_resource_external_identifier` (
    `data_resource_external_identifiers_id` bigint NOT NULL,
    `external_identifier_id` bigint DEFAULT NULL,
    KEY `FKjl7sq5yrmiprjejwno3qhosn9` (`external_identifier_id`),
    KEY `FKhoiygwx6wruolguio186lflgw` (`data_resource_external_identifiers_id`),
    CONSTRAINT `FKhoiygwx6wruolguio186lflgw` FOREIGN KEY (`data_resource_external_identifiers_id`) REFERENCES `data_resource` (`id`),
    CONSTRAINT `FKjl7sq5yrmiprjejwno3qhosn9` FOREIGN KEY (`external_identifier_id`) REFERENCES `external_identifier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `data_resource_external_identifier` (`data_resource_external_identifiers_id`, `external_identifier_id`) select c.id, e.id from external_identifier e inner join data_resource c on e.entity_uid = c.uid;

CREATE TABLE `institution_external_identifier` (
    `institution_external_identifiers_id` bigint NOT NULL,
    `external_identifier_id` bigint DEFAULT NULL,
    KEY `FK1msq9xx132sf5gev64x1yi0ps` (`external_identifier_id`),
    KEY `FKmqbpx6oa6dnybgvaqhp4bbaqd` (`institution_external_identifiers_id`),
    CONSTRAINT `FK1msq9xx132sf5gev64x1yi0ps` FOREIGN KEY (`external_identifier_id`) REFERENCES `external_identifier` (`id`),
    CONSTRAINT `FKmqbpx6oa6dnybgvaqhp4bbaqd` FOREIGN KEY (`institution_external_identifiers_id`) REFERENCES `institution` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into `institution_external_identifier` (`institution_external_identifiers_id`, `external_identifier_id`) select c.id, e.id from external_identifier e inner join institution c on e.entity_uid = c.uid;
