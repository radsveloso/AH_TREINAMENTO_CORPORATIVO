# DRPS — Diagnóstico de Riscos Psicossociais
**AH Treinamento Corporativo**

Sistema completo de coleta e armazenamento de diagnóstico psicossocial (NR-01 / MTE).

---

## Arquivos do Projeto

| Arquivo | Descrição |
|---|---|
| `index.html` | Formulário DRPS (enviado aos colaboradores) |
| `admin.html` | Painel de cadastro de empresas (uso interno AH) |
| `schema.sql` | Schema do banco de dados Supabase |

---

## Setup em 5 passos

### 1. Criar projeto no Supabase
- Acesse [supabase.com](https://supabase.com) → New Project
- Anote a **URL do projeto** e a **anon key** (Settings → API)

### 2. Criar o banco de dados
- No Supabase → SQL Editor → cole todo o conteúdo de `schema.sql` → Run

### 3. Configurar as credenciais

Em **`index.html`** (linha ~440):
```js
const SUPABASE_URL = 'https://SEU_PROJETO.supabase.co';
const SUPABASE_KEY = 'SUA_ANON_KEY';
```

Em **`admin.html`** (linha ~215):
```js
const SUPABASE_URL = 'https://SEU_PROJETO.supabase.co';
const SUPABASE_KEY = 'SUA_SERVICE_ROLE_KEY'; // Settings → API → service_role
const BASE_URL = 'https://SEU_DOMINIO/index.html';
```

### 4. Publicar no GitHub Pages
```bash
git init
git add .
git commit -m "feat: DRPS v1.0"
git remote add origin https://github.com/SEU_USUARIO/drps-ah.git
git push -u origin main
```
Depois: GitHub → Settings → Pages → Branch: main → Save

### 5. Criar usuário admin no Supabase
- Supabase → Authentication → Users → Add User
- Use as credenciais para login no `admin.html`

---

## Como funciona

```
AH cadastra empresa no admin.html
        ↓
Gera código único (ex: EMP4521)
        ↓
Link: https://seusite.github.io/index.html?code=EMP4521
        ↓
Colaborador abre o link → responde as 52 questões
        ↓
Respostas gravadas no Supabase com company_code
        ↓
Dashboard futuro: empresa acessa os resultados
```

---

## Segurança (LGPD)
- Sem dados pessoais identificáveis no banco
- Row Level Security ativada (anon só insere, nunca lê)
- Respostas analisadas somente de forma coletiva
- View `company_scores` calcula scores por tópico sem expor respostas individuais

---

## Roadmap
- [ ] Dashboard por empresa (scores por tópico, tendências)
- [ ] Exportação de relatório PDF por empresa
- [ ] Comparativo entre setores
- [ ] Alerta automático por e-mail ao atingir N respostas
