# CS 182 Special Participation Directory

This static website consolidates all five CS 182 Special Participation categories (A–E) from Ed Discussion into a unified, searchable, and browsable directory. Instead of scrolling through hundreds of posts across five separate threads, submissions become a structured resource for studying LLM capabilities, discovering creative educational tools, and reviewing peer work at scale.

## User-facing features

### Home page

- Dynamic statistics for total submissions and unique students
- Pinned and notable threads highlighted for each participation category
- Quick navigation to all five participation tabs

### Participation tabs (A–E)

- Card-based grid layout for all submissions
- Full-text search across title, author, and content
- Filters for model or LLM family: GPT, Claude, Gemini, DeepSeek, Grok, Mistral, and Cursor
- Homework filters for categories A and B, covering HW0–HW13
- Tool-category filters for category E: Interactive Tutor, Concept Review, Visualization Tool, Quiz/Exam Prep, Practice Problems, Code Helper, Learning Game, and Discussion
- Optimizer filters for category D: Muon, Lion, SOAP, Shampoo, MuP, LR-Scaling, and Polar Express
- Performance summaries for categories A and B, aggregating LLM strengths and weaknesses by homework
- Pagination with 24 cards per page
- URL-based routing with shareable links

### Course Topics page

- Top five threads per topic across all participation categories
- Six course topics: Optimizers, CNNs/GNNs, RNN/SSM, Transformers/Attention, Fine-tuning/ICL, and Generative Models
- Threads ranked with LLM-based quality scoring

## Data pipeline

### Scraping and extraction

- Ed Discussion API integration using the `edapi` package
- Extraction of thread titles, authors, dates, content, and attachments

### Classification and tagging

- Regex-based model-family detection from submission content
- Pattern-based homework classification
- Detection of novel optimizers in category D
- LLM-based categorization of category E submissions into eight tool types
- LLM-based mapping to six course topics

### LLM-based scoring

- OpenAI API quality scoring for educational value
- Generated reasoning for each score
- Aggregated scores for topic rankings
- Manual curation of top threads per topic

### Manual overrides

- Model-family corrections for ambiguous cases
- Homework-classification fixes
- Pinned-thread selection per category

## Technical stack

- Pure HTML, CSS, and JavaScript with no framework dependencies
- Static deployment on Vercel
- Structured JSON data files

## Dataset scale

- Five participation categories
- More than 500 submissions
- HW0–HW13 coverage
- More than seven LLM families, seven optimizer types, eight tool categories, and six course topics

## Development process

Claude Sonnet 4 and Opus 4.5 were used iteratively throughout development:

1. **Data pipeline:** Python scripts scrape Ed, parse content, and classify submissions using regex and LLM-based analysis.
2. **Website foundation:** HTML, CSS, and JavaScript provide tab navigation, card layouts, and filtering.
3. **Enhanced features:** Pinned threads, performance summaries, topic classification, the Course Topics page, and quality scoring.
4. **Deployment:** The site is configured for static hosting on Vercel.

The code was generated through conversational prompting with Claude.
