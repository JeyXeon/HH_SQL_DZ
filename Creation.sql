CREATE TABLE public.employer
(
    "Id" integer NOT NULL DEFAULT nextval('"employer_Id_seq"'::regclass),
    "Name" character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT employer_pkey PRIMARY KEY ("Id")
);

CREATE TABLE public.response
(
    "Id" integer NOT NULL DEFAULT nextval('"response_Id_seq"'::regclass),
    "Date" date,
    "Summary_id" integer NOT NULL DEFAULT nextval('"response_Summary_id_seq"'::regclass),
    CONSTRAINT response_pkey PRIMARY KEY ("Id"),
    CONSTRAINT summary_ref FOREIGN KEY ("Summary_id")
        REFERENCES public.summary ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE public.summary
(
    "Id" integer NOT NULL DEFAULT nextval('"summary_Id_seq"'::regclass),
    "Desired_position" character varying(30) COLLATE pg_catalog."default",
    "Desired_compensation" integer,
    CONSTRAINT summary_pkey PRIMARY KEY ("Id")
);

CREATE TABLE public.vacancy
(
    "Id" integer NOT NULL DEFAULT nextval('"vacancy_Id_seq"'::regclass),
    "Name" character varying(30) COLLATE pg_catalog."default" NOT NULL,
    "Compensation_from" integer,
    "Compensation_to" integer,
    "Compensation_gross" boolean,
    "Area_id" integer NOT NULL DEFAULT nextval('"vacancy_Area_id_seq"'::regclass),
    "Created_at" date,
    CONSTRAINT vacancy_pkey PRIMARY KEY ("Id"),
    CONSTRAINT area_ref FOREIGN KEY ("Area_id")
        REFERENCES public.area ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

CREATE TABLE public.vacancy_response
(
    vacancy_id integer NOT NULL DEFAULT nextval('vacancy_response_vacancy_id_seq'::regclass),
    response_id integer NOT NULL DEFAULT nextval('vacancy_response_response_id_seq'::regclass),
    "Id" integer NOT NULL DEFAULT nextval('"vacancy_response_Id_seq"'::regclass),
    CONSTRAINT vacancy_response_pkey PRIMARY KEY ("Id"),
    CONSTRAINT response_ref FOREIGN KEY (response_id)
        REFERENCES public.response ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT vacancy_ref FOREIGN KEY (vacancy_id)
        REFERENCES public.vacancy ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE public.employer_vacancy
(
    "Id" integer NOT NULL DEFAULT nextval('"employer_vacancy_Id_seq"'::regclass),
    "Employer_id" integer NOT NULL DEFAULT nextval('"employer_vacancy_Employer_id_seq"'::regclass),
    "Vacancy_id" integer NOT NULL DEFAULT nextval('"employer_vacancy_Vacancy_id_seq"'::regclass),
    CONSTRAINT employer_vacancy_pkey PRIMARY KEY ("Id"),
    CONSTRAINT "Employer_ref" FOREIGN KEY ("Employer_id")
        REFERENCES public.employer ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Vacancy_ref" FOREIGN KEY ("Vacancy_id")
        REFERENCES public.vacancy ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
