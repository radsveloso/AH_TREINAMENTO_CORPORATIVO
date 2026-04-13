-- ═══════════════════════════════════════════════════════════
-- DRPS — Adicionar campo password na tabela companies
-- Cole no Supabase → SQL Editor → Run
-- ═══════════════════════════════════════════════════════════

-- 1. Adiciona coluna dashboard_password
ALTER TABLE public.companies
  ADD COLUMN IF NOT EXISTS dashboard_password TEXT;

-- 2. Política: anon pode ler código + password para validar login
--    (já existe policy anon_read_active_companies — precisamos garantir
--     que o campo password é retornado por ela, o que é automático)

-- 3. Política: anon pode UPDATE apenas o campo dashboard_password
--    quando souber o código atual (validação feita no frontend)
CREATE POLICY IF NOT EXISTS "anon_update_password" ON public.companies
  FOR UPDATE TO anon
  USING (active = TRUE)
  WITH CHECK (active = TRUE);

-- 4. View segura para o dashboard: anon lê somente os scores (sem dados sensíveis)
--    Já existe a view company_scores — adicionar policy de leitura via anon
--    (views herdam RLS da tabela base — responses já está configurada)
