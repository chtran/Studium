class Database < Thor
  desc "populate [FILENAME]","populate the database with SAT questions."
  method_options force: :boolean
  method_options verbose: :boolean
  def populate(filename)
    require File.expand_path("config/environment.rb")

    # Read the specified file and create questions
    verbose=options[:verbose]
    file=File.open filename,"r"
    lines=IO.readlines filename
    question=nil
    type=nil
    paragraph=nil
    lines.each do |line|
      if line=~/Paragraph:$/
        paragraph=Paragraph.new
      end

      if line=~/Paragraph Title:\s?(.+)/
        paragraph.title=$1.rstrip
      end

      if line=~/Paragraph Content:\s?(.+)/
        paragraph.content=$1.rstrip
      end

      if line=~/\<End Paragraph\>/
        paragraph.save!
        puts "Created Paragraph with id #{paragraph.id}" if verbose
        paragraph=nil
      end

<<<<<<< HEAD
      if line=~/Question:\s?CR\((.+)\)/m or line=~/Question:\s?Math\((.+)\)/m or line=~/Question:\s?Writing\((.+)\)/m
=======
      if line=~/Question:\s?CR\((.+)\)/m or line=~/Question:\s?WR\((.+)\)/m or line=~/Question:\s?Math\((.+)\)/m
>>>>>>> 57cb2108a86aa32981fd2d2132dc76696182c6d9
        if options[:force]
          type=$1
        else
          question=question_with_type $1
        end
      end

      if line=~/Prompt:\s?(.+)/m
        if options[:force]
          question=find_or_create_question_with_type_and_prompt(type,$1.rstrip)
          question.choices.each &:destroy if question.choices.any?
        end
        question.prompt=$1.rstrip if question
      end

      if question
        if line=~/Title:\s?(.+)/m
          question.title=$1.rstrip
        elsif line=~/Exp:\s?(.+)/m
          question.exp=$1.rstrip.to_i
        elsif line=~/Choice (\w)(_correct)?:\s?(.+)/m or line=~/\((\w)\)(_correct)?:?\s?(.+)/m
          choice=question.choices.new
          choice.correct=$2=="_correct" || false
          choice.choice_letter=$1
          choice.content=$3.rstrip
          choice.save! 
        elsif line=~/\<End Question\>/
          if question.persisted?
            question.save!
            puts "Updated question with id: #{question.id}" if verbose 
          else
            question.save!
            puts "Created question with id: #{question.id}" if verbose 
          end
          
          if paragraph
            paragraph.questions << question
            paragraph.save!
          end
          question=nil
        end
      end
    end

    if question
      if question.persisted?
        puts "Updated question with id: #{question.id}" if verbose 
        question.save!
      else
        question.save!
        puts "Created question with id: #{question.id}" if verbose 
      end

    end

  rescue Errno::ENOENT => e
    puts "Data file not found."
  rescue ActiveRecord::RecordInvalid => e
    if question && question.errors.any?
      puts "Error for question with title: \"#{question.title}\". #{e.message}"
    elsif paragraph && paragraph.errors.any?
      puts "Error for paragraph with title: \"#{paragraph.title}\". #{e.message}"
    end
  end

  desc "question_with_type [TYPE]","Create a question with a given type."
  def question_with_type(type)
    type=QuestionType.find_by_type_name! type

    question=type.questions.new
    question

  rescue
    puts "Unrecorgnized question type: \"#{type}\""
  end

  desc "find_or_create_question_with_type [TYPE]","Find or create a question with a given type."
  def find_or_create_question_with_type_and_prompt(type,prompt)
    type=QuestionType.find_by_type_name! type

    question=type.questions.find_or_create_by_prompt prompt
    question

  rescue
    puts "Unrecorgnized question type: \"#{type}\""
  end

  desc "reset","reset database without deleting users."
  method_options verbose: :boolean
  def reset
    require File.expand_path("config/environment.rb")

    verbose=options[:verbose]
    Question.destroy_all
    puts "Destroyed all questions" if verbose
    QuestionType.destroy_all
    puts "Destroyed all question types" if verbose
    CategoryType.destroy_all
    puts "Destroyed all category types" if verbose
    Room.destroy_all
    puts "Destroyed all rooms" if verbose
    RoomMode.destroy_all
    puts "Destroyed all room modes" if verbose
    Badge.destroy_all
    puts "Destroyed all badges" if verbose
  end

  desc "seed_badges","seed the database with badges"
  method_options verbose: :boolean
  def seed_badges
    require File.expand_path("config/environment.rb")

    verbose=options[:verbose]
    Badge.create! name: "10-undefeated",description: "10 correct questions in a row."
    puts "Created 10-undefeated badge" if verbose
    Badge.create! name: "50-undefeated",description: "50 correct questions in a row."
    puts "Created 50-undefeated badge" if verbose
    Badge.create! name: "100-undefeated",description: "100 correct questions in a row.",legendary: true 
    puts "Created 100-undefeated badge" if verbose
    Badge.create! name: "Altruist",description: "Received first 10 points of reputation."
    puts "Created Altruist badge" if verbose
    Badge.create! name: "Scholar Lv1",description: "Answered 100 questions."
    puts "Created Scholar Lv1 badge" if verbose
    Badge.create! name: "Scholar Lv2",description: "Answered 1000 questions."
    puts "Created Scholar Lv2 badge" if verbose
    Badge.create! name: "Scholar Lv3",description: "Answered 5000 questions."
    puts "Created Scholar Lv3 badge" if verbose
    Badge.create! name: "Legendary Scholar",description: "Answered 10000 questions.",legendary: true
    puts "Created Legendary Scholar badge" if verbose
    Badge.create! name: "Reviewer",description: "5 perfect replay sessions."
    puts "Created Reviewer badge" if verbose
    Badge.create! name: "Mathematician Lv1",description: "50 correct math questions in total, 5 of which in row."
    puts "Created Mathematician Lv1 badge" if verbose
    Badge.create! name: "Mathematician Lv2",description: "100 correct math questions in total, 20 of which in row."
    puts "Created Mathematician Lv2 badge" if verbose
    Badge.create! name: "Legendary Mathematician",description: "1000 correct math questions in total, 50 of which in row.",legendary: true
    puts "Created Legendary Mathematician badge" if verbose
    Badge.create! name: "Wood Brush",description: "50 correct writing questions."
    puts "Created Wood Brush badge" if verbose
    Badge.create! name: "Gem Pen",description: "100 correct writing questions, 10 of which in a row."
    puts "Created Gem Pen badge" if verbose
    Badge.create! name: "Silver Pen",description: "200 correct writing questions, 20 of which in a row."
    puts "Created Silver Pen badge" if verbose
    Badge.create! name: "Golden Pen",description: "300 correct writing questions, 30 of which in a row."
    puts "Created Golden Pen badge" if verbose
    Badge.create! name: "Platinum Pen",description: "400 correct writing questions, 40 of which in a row."
    puts "Created Platinum Pen badge" if verbose
    Badge.create! name: "Legendary Writer",description: "1000 correct writing questions, 100 of which in a row.",legendary: true
    puts "Created Legendary Writer badge" if verbose
    Badge.create! name: "Avid Reader Lv1",description: "50 correct reading questions, 5 of which in a row."
    puts "Created Avid Reader Lv1 badge" if verbose
    Badge.create! name: "Avid Reader Lv2",description: "100 correct reading questions, 20 of which in a row."
    puts "Created Avid Reader Lv2 badge" if verbose
    Badge.create! name: "Avid Reader Lv3",description: "500 correct reading questions, 50 of which in a row."
    puts "Created Avid Reader Lv3 badge" if verbose
    Badge.create! name: "Bookworm",description: "1000 correct reading questions, 100 of which in a row.",legendary: true
    puts "Created Bookworm badge" if verbose
  end

  desc "seed_question_types","seed the database with Categories and Question Types"
  method_options verbose: :boolean
  def seed_question_types
    require File.expand_path("config/environment.rb")

    verbose=options[:verbose]
    CategoryType.create! category_name: "Critical Reading"
    puts "Created Critical Reading category" if verbose
    CategoryType.create! category_name: "Math"
    puts "Created Math category" if verbose
    CategoryType.create! category_name: "Writing (Multiple Choice)"
    puts "Created Writing (Multiple Choice)" if verbose

    QuestionType.create! type_name: "Sentence Completion",category_type: CategoryType.find_by_category_name!("Critical Reading"),need_paragraph: false
    QuestionType.create! type_name: "Reading",category_type: CategoryType.find_by_category_name!("Critical Reading"),need_paragraph: true
    QuestionType.create! type_name: "Sentence Improvement",category_type: CategoryType.find_by_category_name!("Writing (Multiple Choice)"),need_paragraph: false
    QuestionType.create! type_name: "Error Identification",category_type: CategoryType.find_by_category_name!("Writing (Multiple Choice)"),need_paragraph: false
    QuestionType.create! type_name: "Paragraph Improvement",category_type: CategoryType.find_by_category_name!("Writing (Multiple Choice)"),need_paragraph: true
    QuestionType.create! type_name: "Math (Multiple Choice)",category_type: CategoryType.find_by_category_name!("Math"),need_paragraph: false
    QuestionType.create! type_name: "Math (Grid-in)",category_type: CategoryType.find_by_category_name!("Math"),need_paragraph: false
  end

  desc "seed_room_modes","seed the database with room modes"
  method_options verbose: :boolean
  def seed_room_modes
    require File.expand_path("config/environment.rb")

    verbose=options[:verbose]
    RoomMode.create! title: "Replay", namespace: "replay"
    puts "Created Replay room mode" if verbose
    RoomMode.create! title: "Shuffled", namespace: "shuffled"
    puts "Created Shuffled room mode" if verbose
    RoomMode.create! title: "Smart", namespace: "smart"
    puts "Created Smart room mode" if verbose
    RoomMode.create! title: "Math", namespace: "math"
    puts "Created Math room mode" if verbose
    RoomMode.create! title: "Writing (Multiple Choice)", namespace: "writing"
    puts "Created Writing (Multiple Choice) room mode" if verbose
    RoomMode.create! title: "Critical Reading", namespace: "cr"
    puts "Created Critical Reading room mode" if verbose
  end

  desc "seed","seed database with initial data"
  method_options reset: :boolean
  method_options verbose: :boolean
  def seed
    require File.expand_path("config/environment.rb")
    
    # Reset if desired
    if options[:reset]
      reset
    end

    # Seed database
    seed_question_types
    seed_room_modes
    seed_badges
  end
end
