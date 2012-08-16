CategoryType.create! category_name: "Critical Reading"
CategoryType.create! category_name: "Math"
CategoryType.create! category_name: "Writing (Multiple Choice)"

QuestionType.create! type_name: "Sentence Completion",category_type: CategoryType.find_by_category_name!("Critical Reading"),need_paragraph: false
QuestionType.create! type_name: "Reading",category_type: CategoryType.find_by_category_name!("Critical Reading"),need_paragraph: true
QuestionType.create! type_name: "Sentence Improvement",category_type: CategoryType.find_by_category_name!("Writing (Multiple Choice)"),need_paragraph: false
QuestionType.create! type_name: "Error Identification",category_type: CategoryType.find_by_category_name!("Writing (Multiple Choice)"),need_paragraph: false
QuestionType.create! type_name: "Paragraph Improvement",category_type: CategoryType.find_by_category_name!("Writing (Multiple Choice)"),need_paragraph: true
QuestionType.create! type_name: "Math (Multiple Choice)",category_type: CategoryType.find_by_category_name!("Math"),need_paragraph: false
QuestionType.create! type_name: "Math (Grid-in)",category_type: CategoryType.find_by_category_name!("Math"),need_paragraph: false

RoomMode.create! title: "Shuffled"
RoomMode.create! title: "Math"
RoomMode.create! title: "Critical Reading"
RoomMode.create! title: "Writing (Multiple Choice)"
RoomMode.create! title: "Replay"

q1 = QuestionType.first.questions.new title: "Test 1", prompt: "This is the <bl /> question"
q1.choices.new choice_letter: "A", content: "first", correct: true
q1.choices.new choice_letter: "B", content: "second", correct: false
q1.choices.new choice_letter: "C", content: "third", correct: false
q1.choices.new choice_letter: "D", content: "fourth", correct: false
q1.choices.new choice_letter: "E", content: "last", correct: false
q1.save!

q1 = QuestionType.first.questions.new title: "Test 2", prompt: "This is the <bl /> question"
q1.choices.new choice_letter: "A", content: "first", correct: false
q1.choices.new choice_letter: "B", content: "second", correct: true
q1.choices.new choice_letter: "C", content: "third", correct: false
q1.choices.new choice_letter: "D", content: "fourth", correct: false
q1.choices.new choice_letter: "E", content: "last", correct: false
q1.save!
