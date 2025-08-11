import openai

openai.api_key = 'YOUR_API_KEY'

def generate_questions(role, level='intermediate'):
    prompt = f"Generate 5 {level} level interview questions for a {role} role."
    response = openai.ChatCompletion.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}]
    )
    questions = response.choices[0].message.content
    return questions

def evaluate_answer(question, answer):
    prompt = (
        f"Question: {question}\n"
        f"Candidate's answer: {answer}\n"
        "Evaluate the answer, provide a score out of 10, highlight mistakes, and suggest improvements."
    )
    response = openai.ChatCompletion.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": prompt}]
    )
    feedback = response.choices[0].message.content
    return feedback

# Example usage
if __name__ == "__main__":
    role = "backend developer"
    questions = generate_questions(role)
    print("Questions:\n", questions)

    sample_answer = "Binary search works by dividing the array repeatedly."
    feedback = evaluate_answer("Explain binary search.", sample_answer)
    print("Feedback:\n", feedback)

