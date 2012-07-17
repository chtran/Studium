class Database < Thor
  desc "populate [FILENAME]","populate the database with SAT questions."
  method_options force: :boolean
  def populate(filename)
    require File.expand_path("config/environment.rb")

    # Read the specified file and create questions
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
        puts "Created Paragraph with id #{paragraph.id}"
        paragraph=nil
      end

      if line=~/Question:\s?CR\((.+)\)/m or line=~/Question:\s?Math\((.+)\)/m or line=~/Question:\s?Math\((.+)\)/m
        if options[:force]
          type=$1
        else
          question=question_with_type $1
        end
      end

      if line=~/Prompt:\s?(.+)/m
        question=find_or_create_question_with_type_and_prompt(type,$1.rstrip) if options[:force]
        question.prompt=$1.rstrip if question
      end

      if question
        if line=~/Title:\s?(.+)/m
          question.title=$1.rstrip
        elsif line=~/Exp:\s?(.+)/m
          question.exp=$1.rstrip.to_i
        elsif line=~/Choice (\w)(_correct)?:\s?(.+)/m
          choice=question.choices.new
          choice.correct=$2=="_correct" || false
          choice.choice_letter=$1
          choice.content=$3.rstrip
          choice.save! 
        elsif line=~/\<End Question\>/
          if question.persisted?
            question.save!
            puts "Updated question with id: #{question.id}" 
          else
            question.save!
            puts "Created question with id: #{question.id}" 
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
        puts "Updated question with id: #{question.id}" 
        question.save!
      else
        question.save!
        puts "Created question with id: #{question.id}" 
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
end
