CREATE TABLE `data_provider_collection` (
    `data_provider_id` bigint NOT NULL,
    `collection_id` bigint NOT NULL,
    KEY `FKkfqinj4hhx1y9f4sug6krrkkv` (`data_provider_id`),
    KEY `FKo69vyjeqitr73xst7cn8vkj32` (`collection_id`),
    CONSTRAINT `FKkfqinj4hhx1y9f4sug6krrkkv` FOREIGN KEY (`data_provider_id`) REFERENCES `data_provider` (`id`),
    CONSTRAINT `FKo69vyjeqitr73xst7cn8vkj32` FOREIGN KEY (`collection_id`) REFERENCES `collection` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into data_provider_collection (collection_id, data_provider_id) select c.id, d.id from data_link dl inner join collection c on dl.consumer = c.uid inner join data_provider d on dl.provider = d.uid;

CREATE TABLE `data_provider_institution` (
     `data_provider_id` bigint NOT NULL,
     `institution_id` bigint NOT NULL,
     KEY `FKekweu6pqdjjg8lv8bm1mb9q8m` (`institution_id`),
    KEY `FKtl4l7nyivmpsuhqks8c7vr05q` (`data_provider_id`),
    CONSTRAINT `FKekweu6pqdjjg8lv8bm1mb9q8m` FOREIGN KEY (`institution_id`) REFERENCES `institution` (`id`),
    CONSTRAINT `FKtl4l7nyivmpsuhqks8c7vr05q` FOREIGN KEY (`data_provider_id`) REFERENCES `data_provider` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into data_provider_institution (institution_id, data_provider_id) select c.id, d.id from data_link dl inner join institution c on dl.consumer = c.uid inner join data_provider d on dl.provider = d.uid;


CREATE TABLE `data_resource_institution` (
     `data_resource_id` bigint NOT NULL,
     `institution_id` bigint DEFAULT NULL,
     KEY `FKs242vnare7999fp4glq0wvapu` (`institution_id`),
    KEY `FKdvn1twqb3ngbkv75l8lo4exe3` (`data_resource_id`),
    CONSTRAINT `FKdvn1twqb3ngbkv75l8lo4exe3` FOREIGN KEY (`data_resource_id`) REFERENCES `data_resource` (`id`),
    CONSTRAINT `FKs242vnare7999fp4glq0wvapu` FOREIGN KEY (`institution_id`) REFERENCES `institution` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into data_resource_institution (institution_id, data_resource_id) select c.id, d.id from data_link dl inner join institution c on dl.consumer = c.uid inner join data_resource d on dl.provider = d.uid;

CREATE TABLE `data_resource_collection` (
    `collection_id` bigint NOT NULL,
    `data_resource_id` bigint NOT NULL,
    KEY `FKdytubkqq8k13w53us6bap0ad8` (`data_resource_id`),
    KEY `FKgmdx83aviwdxxd61wf4mustfl` (`collection_id`),
    CONSTRAINT `FKdytubkqq8k13w53us6bap0ad8` FOREIGN KEY (`data_resource_id`) REFERENCES `data_resource` (`id`),
    CONSTRAINT `FKgmdx83aviwdxxd61wf4mustfl` FOREIGN KEY (`collection_id`) REFERENCES `collection` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into data_resource_collection (collection_id, data_resource_id) select c.id, d.id from data_link dl inner join collection c on dl.consumer = c.uid inner join data_resource d on dl.provider = d.uid;
