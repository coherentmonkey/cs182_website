# Prompt: Interactive Diffusion Models Visualizer

Create a comprehensive, interactive React visualization tool for understanding diffusion models. This is an educational tool for a deep learning course (CS 182/282A) that helps students build geometric intuition for how diffusion models work.

## Design Philosophy

- **Aesthetic**: Dark, sophisticated, data-visualization inspired. Think: scientific visualization meets modern dashboard. Use deep blues, purples, and accent colors. Avoid generic AI aesthetics.
- **Typography**: Use IBM Plex Sans for UI and IBM Plex Mono for mathematical notation and stats
- **Interactions**: Smooth, responsive, with meaningful animations that reinforce the concepts being taught
- **Education-first**: Every visual element should teach something. No decoration without purpose.

## Core Components

### 1. Main Navigation Tabs
Three main modes:
- **Forward Process**: Visualize q(xₜ | x₀) - adding noise over time
- **Reverse Process**: Visualize p(xₜ₋₁ | xₜ) - denoising over time  
- **Score Function**: Focus on understanding ∇ₓ log p(x)

### 2. 2D Toy Distribution Visualizer (Primary Panel)

**Data Distribution Options** (user can switch between):
- Two Moons
- Mixture of 4 Gaussians (clusters)
- Spiral
- Circle/Ring

**Visualization Features**:
- ~120-150 data points rendered as colored dots
- Points should have colors based on their original position (so you can track where they came from)
- Faint trails connecting current position to original position (shows displacement)
- Background grid for spatial reference
- Axes through center

**Time Slider**:
- Slider from t=0 to t=T (use T=50 timesteps)
- Show current t value prominently
- Labels: "t=0 (clean data)" on left, "t=T (pure noise)" on right

**Animation Controls**:
- Play/Pause button for automatic animation
- Reset button to return to starting state
- Animation should go forward for "Forward Process" tab, backward for "Reverse Process" tab

**Stats Display** (always visible):
- Current timestep: t = X / T
- Signal remaining: √ᾱₜ as percentage
- Noise level: √(1-ᾱₜ) as percentage  
- Raw ᾱₜ value

**Score Field Visualization** (toggle-able):
- Render as vector field (arrows on a grid)
- Arrow direction: points toward high-density regions of the data
- Arrow opacity/intensity: proportional to magnitude
- At low t: detailed, points toward nearby modes
- At high t: smooth, points toward global center
- Use ~15x15 grid of arrows

**Mathematical Details for Implementation**:
```
Beta schedule (linear): β_t = β_min + (β_max - β_min) * (t/T)
  where β_min = 0.0001, β_max = 0.02

Alpha bar: ᾱₜ = ∏_{i=0}^{t} (1 - β_i)

Forward diffusion: x_t = √ᾱₜ · x₀ + √(1-ᾱₜ) · ε, where ε ~ N(0, I)

Score approximation: For visualization, approximate score as weighted sum 
  pointing toward data points, with weights based on Gaussian kernel
  whose bandwidth depends on noise level (1-ᾱₜ)
```

### 3. Real Image Examples Panel (Secondary Panel)

Show a row of images demonstrating the forward process on actual images:
- Use placeholder colored rectangles or simple generated patterns if actual images aren't available
- Show: Clean image → t=T/4 → t=T/2 → t=3T/4 → Pure noise
- Label each with the timestep and noise level
- This helps connect the 2D toy visualization to real image generation

Alternative: Show a simple 8x8 or 16x16 pixel grid that gets progressively noisier, which can actually be computed in the browser.

### 4. Explanation Panel (Right Sidebar)

**Dynamic Content** that changes based on:
- Which tab is active (Forward/Reverse/Score)
- Current timestep value

**Structure**:
1. **Title**: Name of current concept (e.g., "Forward Process: q(xₜ | x₀)")

2. **Description**: 2-3 sentences explaining what's happening at the current timestep. Should vary based on t:
   - t ≈ 0: Talk about clean data, the data manifold
   - t ≈ T/4: Structure still visible, noise starting to blur
   - t ≈ T/2: Balanced regime, interesting for learning
   - t ≈ 3T/4: Structure mostly destroyed
   - t ≈ T: Pure Gaussian noise

3. **Math Block**: Show the relevant equation in monospace with nice formatting
   - Forward: `x_t = √ᾱₜ · x₀ + √(1-ᾱₜ) · ε`
   - Reverse: `x_{t-1} = (x_t - (1-α_t)/√(1-ᾱₜ) · s_θ(x_t,t)) / √α_t + σ_t·z`
   - Score: `s_θ(x_t, t) ≈ ∇_x log p(x_t)`

4. **Key Insight Box**: Highlighted box with core takeaway for current mode

5. **Connection to Images**: Brief note on how this applies to actual image generation

### 5. Natural Image Manifold Diagram

A conceptual SVG illustration showing:
- Large box representing "all possible pixel values" (labeled as such)
- Curved line/surface representing the "natural image manifold"
- Green dots on the manifold labeled "real images"
- Red dot off the manifold labeled "noisy image"
- Purple arrow from noisy point toward manifold labeled "score"

This should be a static but well-designed diagram that reinforces the geometric intuition.

### 6. Sampling Trajectories Visualization

When in "Reverse Process" mode, add option to show:
- Multiple (3-5) reverse trajectories starting from the same noise
- Each trajectory in a different color
- Shows the stochasticity of sampling (different paths, same destination region)
- Toggle: "Show multiple trajectories"

### 7. DDPM vs DDIM Comparison (Optional Advanced Feature)

A toggle or separate sub-tab showing:
- DDPM: Stochastic sampling (multiple different trajectories)
- DDIM: Deterministic sampling (same trajectory every time)
- Side-by-side or overlay visualization

### 8. Quiz/Self-Assessment Section

Include 2-3 interactive quiz questions at the bottom:

**Question 1** (about score at different noise levels):
"At t = T/2, which statement about the score function is most accurate?"
- A) Points uniformly toward center
- B) Still reflects multi-modal structure but smoothed ✓
- C) Original structure completely destroyed
- D) Forward and reverse are symmetric

**Question 2** (about the manifold):
"Why can we start from pure Gaussian noise when generating images?"
- A) The neural network memorizes all training images
- B) At t=T, the noisy data distribution ≈ N(0,I), so we can sample from that ✓
- C) The forward process is reversible without learning
- D) Gaussian noise contains hidden image information

**Question 3** (about the loss):
"The diffusion training objective is equivalent to:"
- A) Reconstructing the original image directly
- B) Predicting the noise that was added ✓ (or equivalently, the score)
- C) Classifying which timestep we're at
- D) Maximizing likelihood directly

Each question should:
- Show options as clickable cards
- On selection, show explanation of why the answer is correct/incorrect
- Use color coding (green for correct, red for incorrect)

### 9. Socratic Probing Questions

Throughout the interface, include prompting questions that encourage active thinking:

- Near the time slider: "What happens to the score field as you increase t? Why?"
- Near the distribution selector: "How does the shape of the data distribution affect how quickly structure is destroyed?"
- Near the trajectory visualization: "Why do different reverse trajectories end up at different points, even starting from the same noise?"

These should be styled as subtle callout boxes that invite reflection.

## Technical Implementation Notes

### State Management
```javascript
const [activeTab, setActiveTab] = useState('forward'); // 'forward' | 'reverse' | 'score'
const [timeStep, setTimeStep] = useState(0); // 0 to T
const [distribution, setDistribution] = useState('moons');
const [showScore, setShowScore] = useState(false);
const [showTrajectories, setShowTrajectories] = useState(false);
const [isPlaying, setIsPlaying] = useState(false);
const [quizAnswers, setQuizAnswers] = useState({});
```

### Animation
- Use `useEffect` with `setInterval` for play/pause
- Forward mode: increment t from 0 to T
- Reverse mode: decrement t from T to 0
- ~100ms per frame for smooth animation

### Deterministic Noise
For consistent visualization (same points go to same places when scrubbing):
```javascript
const seededRandom = (seed) => {
  const x = Math.sin(seed * 12.9898) * 43758.5453;
  return x - Math.floor(x);
};
// Use point.id as seed for its noise values
```

### Score Field Computation
Approximate score as kernel density gradient:
```javascript
// For each grid point, compute weighted direction toward data
// Weight by Gaussian kernel with bandwidth ~ sqrt(1 - alpha_bar)
// Normalize for visualization
```

### Coordinate Transform
```javascript
const toScreen = (x, y, width, height) => ({
  x: (x + 1.5) / 3 * width,   // map [-1.5, 1.5] to [0, width]
  y: (1.5 - y) / 3 * height   // map [-1.5, 1.5] to [0, height], flipped
});
```

## Visual Design Specifications

### Color Palette
- Background: `#0a0a0f` to `#1a1a2e` gradient
- Primary accent: `#667eea` (purple-blue)
- Secondary accent: `#764ba2` (purple)
- Success/Signal: `#4ade80` (green)
- Error/Noise: `#f87171` (red)
- Score field: `#a78bfa` (light purple)
- Text primary: `#e0e0e0`
- Text secondary: `#a0a0a0`
- Text muted: `#666666`

### Component Styling
- Panels: `background: #111`, `border: 1px solid #222`, `border-radius: 12px`
- Buttons: Gradient background for primary, outlined for secondary
- Math blocks: Monospace font, dark background, left border accent
- Hover states: Subtle glow or border color change

### Responsive Considerations
- Main layout: Flex with visualization on left (flex: 1), explanation on right (fixed width ~340px)
- On smaller screens, stack vertically
- SVG viewBox for scalable visualization

## Additional Features to Consider

1. **Loss Landscape Visualization**: Show a simplified view of what the denoising loss looks like

2. **Step-by-Step Mode**: Instead of continuous slider, button to step through discrete timesteps with detailed explanation at each

3. **"What the Network Sees" Panel**: At current timestep, show what information the denoising network has access to

4. **Noise Schedule Comparison**: Toggle between linear, cosine, and other schedules to see effect

5. **Export/Share**: Button to capture current visualization state as image

## Final Notes

The goal is for a student to:
1. Load this tool
2. Play with the forward process on different distributions
3. Observe how the score field changes with noise level
4. Understand why we can start from pure noise
5. See the reverse process as "following the score back to data"
6. Test their understanding with the quiz questions
7. Leave with strong geometric intuition for diffusion

Every element should serve this educational purpose. Avoid feature creep that doesn't teach something new.
