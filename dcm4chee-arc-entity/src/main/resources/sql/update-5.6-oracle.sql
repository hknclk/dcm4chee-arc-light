alter table patient add num_studies number(10,0);
update patient set num_studies = (
  select count(*) from study where study.patient_fk=patient.pk and study.rejection_state in (0,1));
alter table patient modify num_studies not null;
create index UK_296rccryifu6d8byisl2f4dvq on patient (num_studies);

alter table location add ( multi_ref number(10,0), uidmap_fk number(19,0), object_type number(10,0));
update location set object_type = 0;
alter table location modify object_type not null;
alter table location modify tsuid null;
create table uidmap (pk number(19,0) not null, uidmap blob not null, primary key (pk));

alter table instance add inst_no_int number(10,0);
update instance set inst_no_int = inst_no where inst_no != '*';
alter table instance drop column inst_no;
alter table instance rename column inst_no_int to inst_no;
alter table series add series_no_int number(10,0);
update series set series_no_int = series_no where series_no != '*';
alter table series drop column series_no;
alter table series rename column series_no_int to series_no;

create index UK_i1lnahmehau3r3j9pdyxg3p3y on location (multi_ref);
alter table location add constraint FK_bfk5vl6eoxaf0hhwiu3rbgmkn foreign key (uidmap_fk) references uidmap;
create index FK_bfk5vl6eoxaf0hhwiu3rbgmkn on location (uidmap_fk) ;
create sequence uidmap_pk_seq;

create index UK_j6aadbh7u93bpmv18s1inrl1r on series (failed_retrieves);
create index UK_9qvng5j8xnli8yif7p0rjngb2 on study (failed_retrieves);

create index UK_twtj9t0jbl07buyisdtvqrpy on series (failed_iuids);
create index UK_btfu9p1kwhrr444muytvxguci on study (failed_iuids);