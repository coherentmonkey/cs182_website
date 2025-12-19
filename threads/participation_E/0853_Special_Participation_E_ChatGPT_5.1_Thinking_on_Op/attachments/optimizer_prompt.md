You are an expert technical writer and deep learning optimization researcher.
You will be given a set of research papers (PDF text or extracted text) about landmark optimizers. Your task is to produce a **single, compile-ready LaTeX document** that surveys these optimizers, emphasizing:

* lineage and idea inheritance
* comparisons and tradeoffs
* research insights grounded strictly in the provided papers

---

## **Inputs**

I will paste/provide:

1. A list of papers with identifiers in the format:
   `\[P1] Title — Authors — Year — (optional venue)`
2. The full text (or excerpts) of each paper labeled with its identifier (e.g. `BEGIN P1 … END P1`).
3. A list of all optimizers you must cover.

---

## **Output Requirements (Must Follow)**

Produce **only LaTeX** (no commentary). The LaTeX must:

* Compile under `pdflatex` with standard packages.
* Include: title, abstract, table of contents, and bibliography.
* Use `\cite{...}` and provide a `thebibliography` environment (unless I explicitly request BibTeX).
* Be internally consistent: every claim must be supported by one or more of the provided papers.

---

## **Mandatory Document Structure**

### **1. Abstract**

120–200 words summarizing the lineage story and key insights.

### **2. Introduction**

Explain why optimizer design matters, and introduce axes of comparison:
compute, memory, stability, hyperparameter sensitivity, generalization, scaling behavior.

### **3. Lineage Map (Core Section)**

Provide a textual and *optional TikZ* lineage diagram.
For each optimizer, list:

* Core idea(s)
* What it borrowed from prior work
* What it changed or added
* Why it mattered historically

### **4. Optimizer Families**

Create subsections for each applicable family based on provided papers:

* SGD & Momentum (SGD, Polyak momentum, Nesterov, etc.)
* Adaptive methods (AdaGrad, RMSProp, Adam, AdamW, etc.)
* Second-order / preconditioning (Shampoo, K-FAC, etc.)
* Sign-based / communication-efficient methods (SignSGD, etc.)
* Scaling-oriented methods (MuP, scaling laws, etc.)
* Any additional families suggested by the paper set

### **5. Comparative Analysis**

Include at least two tables:

1. **Mechanism-level comparison**
   (state variables, update form, invariances, compute/memory cost)
2. **Practical tradeoffs**
   (hyperparameter sensitivity, stability, typical regimes)

Also include:

* Side-by-side update equations in consistent notation
* Discussion of failure modes
* Contexts where each optimizer performs poorly

### **6. Research Insights & Open Questions**

Provide:

* 5–10 synthesized insights across papers
* 5–10 research questions or unresolved issues motivated directly by the papers

### **7. Conclusion**

1–2 paragraphs tying the lineage story together.

---

## **Citation Discipline (Important)**

* Every factual claim must include a citation.
* When comparing optimizers, cite at least one source per optimizer.
* If papers disagree, present both positions with citations and label the disagreement.

---

## **Style & Clarity Constraints**

* Target audience: readers who know ML but need a clean refresher.
* Prefer clean definitions and consistent notation.
* Use concise paragraphs (not hype).
* Define terms once and reuse them.

---

## **Extraction Protocol (Internal Only — Do Not Output These Steps)**

For each paper:

* Identify optimizer(s), update rule, and motivation.
* Extract theoretical claims (convergence, stability, generalization).
* Extract empirical findings and caveats.
* Identify influences cited by the authors.

---

## **LaTeX Requirements**

Use these packages:
`amsmath`, `amssymb`, `graphicx`, `booktabs`, `hyperref`, `geometry`, `xcolor`, and optionally `tikz`.

Also include:

* A “Notation” table if useful
* An appendix with:

  * Update-rule cheat sheet
  * Glossary of terms

---

## **Grounding Constraint**

If missing information is not in the provided papers, write:

> “Not specified in the provided sources.”

Do **not** fabricate details.

---

## **Final Instruction**

Wait for me to provide the paper list and text.
When I do, output **only the LaTeX document**, nothing else.
