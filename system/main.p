import React, { useState } from "react";

export default function App() {
  const [role, setRole] = useState("backend developer");
  const [level, setLevel] = useState("intermediate");
  const [questions, setQuestions] = useState([]);
  const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
  const [answer, setAnswer] = useState("");
  const [feedback, setFeedback] = useState("");

  async function getQuestions() {
    const res = await fetch("http://127.0.0.1:8000/generate-questions", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ role, level }),
    });
    const data = await res.json();
    const qs = data.questions.split("\n").filter(q => q.trim() !== "");
    setQuestions(qs);
    setCurrentQuestionIndex(0);
    setAnswer("");
    setFeedback("");
  }

  async function sendAnswer() {
    const question = questions[currentQuestionIndex];
    const res = await fetch("http://127.0.0.1:8000/evaluate-answer", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ question, answer }),
    });
    const data = await res.json();
    setFeedback(data.feedback);
  }

  function nextQuestion() {
    if (currentQuestionIndex + 1 < questions.length) {
      setCurrentQuestionIndex(currentQuestionIndex + 1);
      setAnswer("");
      setFeedback("");
    }
  }

  return (
    <div style={{ maxWidth: 500, margin: "20px auto", fontFamily: "Arial" }}>
      <h1>Mockora Interview</h1>
      <div>
        <label>
          Role:{" "}
          <input
            type="text"
            value={role}
            onChange={(e) => setRole(e.target.value)}
          />
        </label>
      </div>
      <div>
        <label>
          Level:{" "}
          <select value={level} onChange={(e) => setLevel(e.target.value)}>
            <option value="easy">Easy</option>
            <option value="intermediate">Intermediate</option>
            <option value="hard">Hard</option>
          </select>
        </label>
      </div>
      <button onClick={getQuestions} style={{ marginTop: 10 }}>
        Get Questions
      </button>
      {questions.length > 0 && (
        <div>
          <h3>Question:</h3>
          <p>{questions[currentQuestionIndex]}</p>
          <textarea
            rows="4"
            cols="50"
            placeholder="Type your answer here..."
            value={answer}
            onChange={(e) => setAnswer(e.target.value)}
          />
          <br />
          <button onClick={sendAnswer} style={{ marginTop: 10 }}>
            Submit Answer
          </button>
          <button
            onClick={nextQuestion}
            style={{ marginLeft: 10, marginTop: 10 }}
            disabled={currentQuestionIndex + 1 >= questions.length}
          >
            Next Question
          </button>
          {feedback && (
            <div>
              <h4>Feedback:</h4>
              <pre>{feedback}</pre>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

