# Behavioral guidelines

The most common failure modes when AI writes code (after Karpathy):

1. **Don't assume — surface confusion.** State assumptions; if multiple interpretations exist, present them instead of picking silently. If a simpler approach exists, say so. If something is unclear: stop, name it, ask.
2. **Minimum viable code.** The least code that solves the problem — nothing speculative, no unrequested features, no abstractions for single-use code. If 200 lines could be 50, rewrite. Test: "would a senior engineer call this overcomplicated?"
3. **Surgical changes only.** Touch only what the task needs. Don't fix adjacent code, refactor unasked, remove code you don't understand, or clean up unrelated imports. Every change traces to the task.
4. **Goal-driven verification.** Turn "make it work" into a testable done-state: write the test, watch it fail, fix, watch it pass. Can't define done? The task isn't clear yet — return to rule 1.
