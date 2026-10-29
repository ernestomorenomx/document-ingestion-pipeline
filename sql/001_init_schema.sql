--
-- PostgreSQL database dump
--


-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 16.14 (Debian 16.14-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: update_content_tsv(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_content_tsv() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.content_tsv := to_tsvector('spanish', 
    COALESCE(NEW.content_md, '') || ' ' || 
    COALESCE(NEW.original_name, '') || ' ' || 
    COALESCE(NEW.category, '') || ' ' || 
    COALESCE(NEW.summary, ''));
  RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: client; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL
);


--
-- Name: document; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.document (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hash_sha256 character(64) NOT NULL,
    original_name text NOT NULL,
    mime_type text NOT NULL,
    raw_path text NOT NULL,
    content_md text,
    content_tsv tsvector,
    category text,
    summary text,
    status text DEFAULT 'pending'::text NOT NULL,
    version_lock integer DEFAULT 1 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    source text DEFAULT 'upload'::text,
    has_images boolean DEFAULT false,
    image_paths text[],
    ocr_engine text
);


--
-- Name: document_client; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.document_client (
    document_id uuid NOT NULL,
    client_id uuid NOT NULL,
    project_id uuid
);


--
-- Name: processing_queue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.processing_queue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    document_id uuid NOT NULL,
    task_type text NOT NULL,
    priority integer DEFAULT 5 NOT NULL,
    estimated_pages integer,
    status text DEFAULT 'queued'::text NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: project; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    name text NOT NULL
);


--
-- Name: client client_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (id);


--
-- Name: document_client document_client_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_client
    ADD CONSTRAINT document_client_pkey PRIMARY KEY (document_id, client_id);


--
-- Name: document document_hash_sha256_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT document_hash_sha256_key UNIQUE (hash_sha256);


--
-- Name: document document_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document
    ADD CONSTRAINT document_pkey PRIMARY KEY (id);


--
-- Name: processing_queue processing_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.processing_queue
    ADD CONSTRAINT processing_queue_pkey PRIMARY KEY (id);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: idx_document_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_document_status ON public.document USING btree (status);


--
-- Name: idx_document_tsv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_document_tsv ON public.document USING gin (content_tsv);


--
-- Name: idx_queue_priority; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_queue_priority ON public.processing_queue USING btree (priority, created_at) WHERE (status = 'queued'::text);


--
-- Name: document trigger_update_tsv; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER trigger_update_tsv BEFORE INSERT OR UPDATE ON public.document FOR EACH ROW EXECUTE FUNCTION public.update_content_tsv();


--
-- Name: document_client document_client_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_client
    ADD CONSTRAINT document_client_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: document_client document_client_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_client
    ADD CONSTRAINT document_client_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.document(id);


--
-- Name: document_client document_client_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.document_client
    ADD CONSTRAINT document_client_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.project(id);


--
-- Name: processing_queue processing_queue_document_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.processing_queue
    ADD CONSTRAINT processing_queue_document_id_fkey FOREIGN KEY (document_id) REFERENCES public.document(id);


--
-- Name: project project_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- PostgreSQL database dump complete
--


