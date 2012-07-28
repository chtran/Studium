# Add Category types to categories table
CategoryType.create! category_name: "Critical Reading"
CategoryType.create! category_name: "Math"
CategoryType.create! category_name: "Writing (Multiple Choice)"

QuestionType.create! type_name: "Sentence Completion",category_type: CategoryType.find_by_category_name!("Critical Reading"),need_paragraph: false
QuestionType.create! type_name: "Reading",category_type: CategoryType.find_by_category_name!("Critical Reading"),need_paragraph: true
QuestionType.create! type_name: "Sentence Improvement",category_type: CategoryType.find_by_category_name!("Writing (Multiple Choice)"),need_paragraph: false
QuestionType.create! type_name: "Error Identification",category_type: CategoryType.find_by_category_name!("Writing (Multiple Choice)"),need_paragraph: false
QuestionType.create! type_name: "Paragraph Improvement",category_type: CategoryType.find_by_category_name!("Writing (Multiple Choice)"),need_paragraph: true

Badge.create! name: "10-undefeated",description: "10 correct questions in a row."
Badge.create! name: "50-undefeated",description: "50 correct questions in a row."
Badge.create! name: "100-undefeated",description: "100 correct questions in a row.",legendary: true 
Badge.create! name: "Altruist",description: "Received first 10 points of reputation."
Badge.create! name: "Scholar Lv1",description: "Answered 100 questions."
Badge.create! name: "Scholar Lv2",description: "Answered 1000 questions."
Badge.create! name: "Scholar Lv3",description: "Answered 5000 questions."
Badge.create! name: "Legendary Scholar",description: "Answered 10000 questions.",legendary: true
Badge.create! name: "Reviewer",description: "5 perfect replay sessions."
Badge.create! name: "Mathematician Lv1",description: "50 correct math questions in total, 5 of which in row."
Badge.create! name: "Mathematician LV2",description: "100 correct math questions in total, 20 of which in row."
Badge.create! name: "Legendary Mathematician",description: "1000 correct math questions in total, 50 of which in row.",legendary: true
Badge.create! name: "Wood Brush",description: "50 correct writing questions."
Badge.create! name: "Gem Pen",description: "100 correct writing questions, 10 of which in a row."
Badge.create! name: "Silver Pen",description: "200 correct writing questions, 20 of which in a row."
Badge.create! name: "Golden Pen",description: "300 correct writing questions, 30 of which in a row."
Badge.create! name: "Platinum Pen",description: "400 correct writing questions, 40 of which in a row."
Badge.create! name: "Legendary Writer",description: "1000 correct writing questions, 100 of which in a row.",legendary: true
Badge.create! name: "Avid Reader LV1",description: "50 correct reading questions, 5 of which in a row."
Badge.create! name: "Avid Reader LV2",description: "100 correct reading questions, 20 of which in a row."
Badge.create! name: "Avid Reader LV3",description: "500 correct reading questions, 50 of which in a row."
Badge.create! name: "Bookworm",description: "1000 correct reading questions, 100 of which in a row.",legendary: true
