-- ═══════════════════════════════════════════════════════════
-- DRPS — AH Treinamento Corporativo
-- Schema Supabase (PostgreSQL)
-- Patricia (Security/Compliance) · Felipe (Data Engineer)
-- ═══════════════════════════════════════════════════════════

-- ── Habilitar extensões ──────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ═══════════════════════════════════════════
-- TABELA: companies
-- Cada empresa cadastrada recebe um código
-- único para distribuir aos colaboradores.
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.companies (
  id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  code        TEXT        UNIQUE NOT NULL,          -- Ex: EMPRESA001
  name        TEXT        NOT NULL,                  -- Nome da empresa
  cnpj        TEXT,                                  -- CNPJ (opcional)
  contact     TEXT,                                  -- E-mail do responsável
  active      BOOLEAN     NOT NULL DEFAULT TRUE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Índice para busca por código (frequente)
CREATE INDEX IF NOT EXISTS idx_companies_code ON public.companies(code);

-- ═══════════════════════════════════════════
-- TABELA: responses
-- Cada linha = uma resposta de um colaborador.
-- Sem dados pessoais — totalmente anônimo.
-- ═══════════════════════════════════════════
CREATE TABLE IF NOT EXISTS public.responses (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_code TEXT        NOT NULL REFERENCES public.companies(code) ON DELETE RESTRICT,

  -- Identificação (sem dados pessoais)
  q1_funcao    TEXT,
  q2_setor     TEXT,

  -- Tópico 01 — Assédio
  q3  SMALLINT CHECK (q3  BETWEEN 0 AND 4),
  q4  SMALLINT CHECK (q4  BETWEEN 0 AND 4),
  q5  SMALLINT CHECK (q5  BETWEEN 0 AND 4),
  q6  SMALLINT CHECK (q6  BETWEEN 0 AND 4),
  q7  SMALLINT CHECK (q7  BETWEEN 0 AND 4),

  -- Tópico 02 — Suporte e Apoio
  q8  SMALLINT CHECK (q8  BETWEEN 0 AND 4),
  q9  SMALLINT CHECK (q9  BETWEEN 0 AND 4),
  q10 SMALLINT CHECK (q10 BETWEEN 0 AND 4),
  q11 SMALLINT CHECK (q11 BETWEEN 0 AND 4),
  q12 SMALLINT CHECK (q12 BETWEEN 0 AND 4),

  -- Tópico 03 — Gestão de Mudanças
  q13 SMALLINT CHECK (q13 BETWEEN 0 AND 4),
  q14 SMALLINT CHECK (q14 BETWEEN 0 AND 4),
  q15 SMALLINT CHECK (q15 BETWEEN 0 AND 4),
  q16 SMALLINT CHECK (q16 BETWEEN 0 AND 4),

  -- Tópico 04 — Clareza de Papel
  q17 SMALLINT CHECK (q17 BETWEEN 0 AND 4),
  q18 SMALLINT CHECK (q18 BETWEEN 0 AND 4),
  q19 SMALLINT CHECK (q19 BETWEEN 0 AND 4),
  q20 SMALLINT CHECK (q20 BETWEEN 0 AND 4),

  -- Tópico 05 — Recompensas e Reconhecimento
  q21 SMALLINT CHECK (q21 BETWEEN 0 AND 4),
  q22 SMALLINT CHECK (q22 BETWEEN 0 AND 4),
  q23 SMALLINT CHECK (q23 BETWEEN 0 AND 4),

  -- Tópico 06 — Autonomia
  q24 SMALLINT CHECK (q24 BETWEEN 0 AND 4),
  q25 SMALLINT CHECK (q25 BETWEEN 0 AND 4),
  q26 SMALLINT CHECK (q26 BETWEEN 0 AND 4),
  q27 SMALLINT CHECK (q27 BETWEEN 0 AND 4),

  -- Tópico 07 — Justiça Organizacional
  q28 SMALLINT CHECK (q28 BETWEEN 0 AND 4),
  q29 SMALLINT CHECK (q29 BETWEEN 0 AND 4),
  q30 SMALLINT CHECK (q30 BETWEEN 0 AND 4),
  q31 SMALLINT CHECK (q31 BETWEEN 0 AND 4),

  -- Tópico 08 — Eventos Traumáticos
  q32 SMALLINT CHECK (q32 BETWEEN 0 AND 4),
  q33 SMALLINT CHECK (q33 BETWEEN 0 AND 4),
  q34 SMALLINT CHECK (q34 BETWEEN 0 AND 4),

  -- Tópico 09 — Subcarga
  q35 SMALLINT CHECK (q35 BETWEEN 0 AND 4),
  q36 SMALLINT CHECK (q36 BETWEEN 0 AND 4),
  q37 SMALLINT CHECK (q37 BETWEEN 0 AND 4),
  q38 SMALLINT CHECK (q38 BETWEEN 0 AND 4),

  -- Tópico 10 — Sobrecarga
  q39 SMALLINT CHECK (q39 BETWEEN 0 AND 4),
  q40 SMALLINT CHECK (q40 BETWEEN 0 AND 4),
  q41 SMALLINT CHECK (q41 BETWEEN 0 AND 4),
  q42 SMALLINT CHECK (q42 BETWEEN 0 AND 4),

  -- Tópico 11 — Relacionamentos
  q43 SMALLINT CHECK (q43 BETWEEN 0 AND 4),
  q44 SMALLINT CHECK (q44 BETWEEN 0 AND 4),
  q45 SMALLINT CHECK (q45 BETWEEN 0 AND 4),

  -- Tópico 12 — Comunicação
  q46 SMALLINT CHECK (q46 BETWEEN 0 AND 4),
  q47 SMALLINT CHECK (q47 BETWEEN 0 AND 4),
  q48 SMALLINT CHECK (q48 BETWEEN 0 AND 4),
  q49 SMALLINT CHECK (q49 BETWEEN 0 AND 4),

  -- Tópico 13 — Trabalho Remoto
  q50 SMALLINT CHECK (q50 BETWEEN 0 AND 4),
  q51 SMALLINT CHECK (q51 BETWEEN 0 AND 4),
  q52 SMALLINT CHECK (q52 BETWEEN 0 AND 4),

  -- Metadata
  submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Índice para filtrar por empresa (dashboard)
CREATE INDEX IF NOT EXISTS idx_responses_company ON public.responses(company_code);
CREATE INDEX IF NOT EXISTS idx_responses_submitted ON public.responses(submitted_at);

-- ═══════════════════════════════════════════
-- ROW LEVEL SECURITY (LGPD + Patricia)
-- ═══════════════════════════════════════════
ALTER TABLE public.companies  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.responses  ENABLE ROW LEVEL SECURITY;

-- Anon: só pode ler empresas ativas (para validar código)
CREATE POLICY "anon_read_active_companies" ON public.companies
  FOR SELECT TO anon
  USING (active = TRUE);

-- Anon: só pode inserir respostas (nunca ler)
CREATE POLICY "anon_insert_responses" ON public.responses
  FOR INSERT TO anon
  WITH CHECK (TRUE);

-- Authenticated (admin): acesso total às próprias respostas
-- (configurar via service_role no admin.html)

-- ═══════════════════════════════════════════
-- VIEW: scores por empresa e tópico
-- Usada no dashboard futuro
-- ═══════════════════════════════════════════
CREATE OR REPLACE VIEW public.company_scores AS
SELECT
  company_code,
  COUNT(*) AS total_responses,

  -- Tópico 01 — Assédio (média)
  ROUND(AVG((q3 + q4 + q5 + q6 + q7)::NUMERIC / 5), 2) AS score_assedio,

  -- Tópico 02 — Suporte
  ROUND(AVG((q8 + q9 + q10 + q11 + q12)::NUMERIC / 5), 2) AS score_suporte,

  -- Tópico 03 — Mudanças
  ROUND(AVG((q13 + q14 + q15 + q16)::NUMERIC / 4), 2) AS score_mudancas,

  -- Tópico 04 — Clareza
  ROUND(AVG((q17 + q18 + q19 + q20)::NUMERIC / 4), 2) AS score_clareza,

  -- Tópico 05 — Reconhecimento
  ROUND(AVG((q21 + q22 + q23)::NUMERIC / 3), 2) AS score_reconhecimento,

  -- Tópico 06 — Autonomia
  ROUND(AVG((q24 + q25 + q26 + q27)::NUMERIC / 4), 2) AS score_autonomia,

  -- Tópico 07 — Justiça
  ROUND(AVG((q28 + q29 + q30 + q31)::NUMERIC / 4), 2) AS score_justica,

  -- Tópico 08 — Trauma
  ROUND(AVG((q32 + q33 + q34)::NUMERIC / 3), 2) AS score_trauma,

  -- Tópico 09 — Subcarga
  ROUND(AVG((q35 + q36 + q37 + q38)::NUMERIC / 4), 2) AS score_subcarga,

  -- Tópico 10 — Sobrecarga
  ROUND(AVG((q39 + q40 + q41 + q42)::NUMERIC / 4), 2) AS score_sobrecarga,

  -- Tópico 11 — Relacionamentos
  ROUND(AVG((q43 + q44 + q45)::NUMERIC / 3), 2) AS score_relacionamentos,

  -- Tópico 12 — Comunicação
  ROUND(AVG((q46 + q47 + q48 + q49)::NUMERIC / 4), 2) AS score_comunicacao,

  -- Tópico 13 — Remoto
  ROUND(AVG((q50 + q51 + q52)::NUMERIC / 3), 2) AS score_remoto,

  -- Score geral (todos os 50 itens)
  ROUND(AVG((
    q3+q4+q5+q6+q7+q8+q9+q10+q11+q12+
    q13+q14+q15+q16+q17+q18+q19+q20+
    q21+q22+q23+q24+q25+q26+q27+q28+
    q29+q30+q31+q32+q33+q34+q35+q36+
    q37+q38+q39+q40+q41+q42+q43+q44+
    q45+q46+q47+q48+q49+q50+q51+q52
  )::NUMERIC / 50), 2) AS score_geral

FROM public.responses
GROUP BY company_code;

-- ═══════════════════════════════════════════
-- EMPRESA DE DEMONSTRAÇÃO (opcional)
-- ═══════════════════════════════════════════
-- INSERT INTO public.companies (code, name, contact)
-- VALUES ('DEMO001', 'Empresa Demonstração', 'rh@empresa.com');
