-- ═══════════════════════════════════════════════════════════
-- DRPS — SQL para o Dashboard (rode no Supabase SQL Editor)
-- ═══════════════════════════════════════════════════════════

-- 1. Adiciona coluna dashboard_password (se ainda não existe)
ALTER TABLE public.companies
  ADD COLUMN IF NOT EXISTS dashboard_password TEXT;

-- 2. Permite que anon atualize a senha (empresa troca própria senha)
DROP POLICY IF EXISTS "anon_update_password" ON public.companies;
CREATE POLICY "anon_update_password" ON public.companies
  FOR UPDATE TO anon
  USING (active = TRUE)
  WITH CHECK (active = TRUE);

-- 3. Permite que anon leia respostas (scores 0-4, sem dados pessoais)
--    Necessário para a view company_scores funcionar no dashboard
DROP POLICY IF EXISTS "anon_read_responses" ON public.responses;
CREATE POLICY "anon_read_responses" ON public.responses
  FOR SELECT TO anon
  USING (true);

-- 4. Garante que a view company_scores é acessível via anon
--    (views herdam RLS da tabela base — policy acima resolve)
GRANT SELECT ON public.company_scores TO anon;
GRANT SELECT ON public.responses TO anon;
GRANT SELECT ON public.companies TO anon;
GRANT UPDATE (dashboard_password) ON public.companies TO anon;
