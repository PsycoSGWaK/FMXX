drop database if exists neigesoleil;
create database neigesoleil;
use neigesoleil;

CREATE TABLE user(
        iduser int(11) NOT NULL AUTO_INCREMENT,
        username varchar (30) not null,
        prenom varchar(25) ,
        dateNaissance date,
        ville varchar(25) ,
        cp varchar(25) ,
        adresse varchar(25) ,
        tel varchar(25),
        nom varchar (30),
        mail varchar (30),
        password varchar (30),
        type varchar(1) DEFAULT '0',
        PRIMARY KEY (iduser)
);

CREATE TABLE employe(
         idemploye int(11) NOT NULL AUTO_INCREMENT,
         username varchar (30),
         prenom varchar(25),
         nom varchar (30),
         mail varchar (30),
         password varchar (30),
         PRIMARY KEY (idemploye)
);

CREATE TABLE habitat(
        idhab int(11) NOT NULL AUTO_INCREMENT,
        libelle varchar (30),
        description varchar (280),
        nbpersonne varchar (30),
        type varchar(30),
        prix varchar(10),
        iduser int not null, 
        PRIMARY KEY (idhab),
        foreign key (iduser) references user(iduser)
);

CREATE TABLE reservation (
        idreser int(11) NOT NULL AUTO_INCREMENT,
        dateA VARCHAR(50),
        dateD VARCHAR(50),
        iduser int not null,
        idhab int not null,
        PRIMARY KEY (idreser),
        foreign key (idhab) references habitat(idhab),
        foreign key (iduser) references user(iduser)
);

CREATE TABLE images (
        idimg int(11) NOT NULL AUTO_INCREMENT,
        url_im varchar(150) ,
        idhab int not null,
        PRIMARY KEY (idimg),
        foreign key (idhab) references habitat(idhab)
);

INSERT INTO user values (NULL,'Pepito','Idgie','1999-02-27','Rouen','76130','2 parc de la varenne','0613198126','T-Paris','idgie@iris.com','password','1');
INSERT INTO user values (NULL,'Granito','Guillaume','1999-02-27','Rouen','76130','2 parc de la varenne','0613198126','Hurard','hurard@iris.com','password','0');
INSERT INTO user values (NULL,'Granita','Guillaume','1999-02-27','Rouen','76130','2 parc de la varenne','0613198126','Hurard','moi@iris.com','password','2');
INSERT INTO employe values (NULL,'Flaflito','Admin','Ladmin','admin@iris.com','password');
INSERT INTO habitat values (NULL, 'Glace', 'test', '14', 'Chalet',"100€",'1');
INSERT INTO habitat values (NULL, 'Sapin', 'Superbe chalet au liserait de la forêt', '5', 'Appartement',"500€",'1');
INSERT INTO habitat values (NULL, 'Casanus', 'Chambre accueillante', '2', 'Appartement',"3000€",'1');
INSERT INTO reservation values (NULL, '1998-02-27', '1999-02-27', '1', '1');
INSERT INTO reservation values (NULL, '2021-02-27', '2023-02-27', '2', '2');
INSERT INTO reservation values (NULL, '2021-01-27', '2023-03-27', '2', '3');

create view dispores(numres,numhab,dated,datefin)
as select idreser,h.idhab,datea,dated 
from reservation r,habitat h
where r.idhab=h.idhab
and dated is null 
union  
select idreser,h.idhab,datea,dated 
from reservation r,habitat h
where r.idhab=h.idhab
and dated <= curdate();

create view reservationclient
as select u.iduser,u.nom,u.prenom,r.idreser,r.datea,r.dated,h.libelle,h.prix
from user u,reservation r,habitat h
where u.iduser=r.iduser
<<<<<<< Updated upstream
and r.idhab=h.idhab;
=======
and r.idhab=h.idhab;

create view locationproprio
as select u.iduser,u.nom,u.prenom,h.idhab,h.libelle,h.type,h.prix
from user u,habitat h
where u.iduser=h.iduser;
>>>>>>> Stashed changes
