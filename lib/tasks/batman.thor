class Batman < Thor

  desc "sc [FILENAME] [SOLFILENAME]","populate the database with SAT sentence completion questions."
  method_options force: :boolean
  method_options verbose: :boolean
  def sc(filename,solfilename)
    require File.expand_path("config/environment.rb")

    verbose=options[:verbose]
    solution = parse_solution(solfilename,verbose)
    file=File.open filename,"r"
    lines=IO.readlines filename
    question_type = QuestionType.where(type_name: "Sentence Completion").first
    question = nil
    num = nil
    prompt = nil
    choice = nil

    lines.each do |line|
      if line=~/^(\d+)\.?\s*(.*\.)\s*$/
        question = question_type.questions.new
        num = $1.to_i
        puts "Creating Question #{num}" if verbose
        prompt = $2.strip.gsub(/--+/,"<bl />")
        puts "Prompt: #{prompt}" if verbose
        question.prompt = prompt
        question.title = prompt.gsub("<bl />","-----").split(/\s+/)[0..5].join(" ")+(" ...")
      elsif line=~ /^([A-E])\.\s*(.*)$/i
        choice = question.choices.new
        correct = solution[num]==$1.upcase
        puts "Choice #{$1}[#{correct.to_s}]: #{$2.strip}" if verbose
        choice.choice_letter=$1.upcase
        choice.content=$2.strip.gsub(/(\s*\.\s*)+/," .. ") 
        choice.correct = correct
        choice.save!
      elsif line=~ /^\s*$/
        if question
          begin
            puts "Saved Question ##{num}" if question.save!
          rescue ActiveRecord::RecordInvalid => e
            if question && question.errors.any?
              puts "Error for question #{num} with title: \"#{question.title}\". #{e.message}"
            end
          end
          question = nil
          num = nil
          choice = nil
          prompt = nil
        end
      else
        puts "Unmatched: #{line}"
      end

    end
  rescue Errno::ENOENT => e
    puts "Data file not found."
  end

  desc "reading [FILENAME] [SOLFILENAME]","populate the database with SAT reading questions."
  def reading(filename, solfilename)
    require File.expand_path("config/environment.rb")

    verbose = options[:verbose]
    solution = parse_solution(solfilename, verbose)
    file = File.open filename, "r"
    lines = IO.readlines filename

    question = nil
    paragraph = nil
    content = nil
    num = nil
    parsing_paragraph = false
    type = QuestionType.where(type_name: "Reading").first
    lines.each do |line|
      #puts "Reading #{line}"
      if line=~/^Paragraph:/
        paragraph=Paragraph.new
        content = ""
        parsing_paragraph = true
      elsif line=~/^--end--$/
        content.gsub!("\n","")
        parsing_paragraph = false
        paragraph = Paragraph.find_by_content(content) || Paragraph.new({content:content})
        paragraph.title=content.split(" ")[0..5].join(" ")+" ..."
      elsif line=~/^(\d+)\.\s*(.*)/
        prompt = $2.strip
        num = $1.to_i
        #puts solution[num]
        question = type.questions.new
        question.title = prompt.split(" ")[0..5].join(" ")+" ..."
        question.prompt = prompt
      elsif line=~/^\(([A-E])\)\s*(.*)/
        correct=(solution[num]==$1.upcase)
        #puts "solution: #{solution[num]}, choice: #{$1.upcase}"
        #puts correct
        question.choices.new({choice_letter: $1.upcase, content: $2.strip, correct: correct})
      elsif line=~/^\s+$/
        if question
          paragraph.questions << question
          question =nil
        end
      elsif line=~/^-----$/
        if question
          paragraph.questions << question
          question = nil
        end
        if paragraph
          begin
            puts "Added Paragraph paragraph #{paragraph.id} with #{paragraph.questions.count} questions" if paragraph.save!
            paragraph=nil
            question =nil
          rescue ActiveRecord::RecordInvalid => e
            if paragraph and paragraph.errors.any?
              error_messages = paragraph.errors.messages
              puts "Error for paragraph with title: \"#{paragraph.title}\". #{e.message}"
              if error_messages[:"questions.prompt"] and error_messages[:"questions.prompt"].include? "has already been taken"
                paragraph.questions.each do |question|
                  if question.question_type.type_name=="Reading" and question.errors.messages[:prompt] and question.errors.messages[:prompt].include? "has already been taken"
                    old_question = Question.find_by_prompt(question.prompt)
                    old_question.update_attribute(:paragraph_id, paragraph.id)
                    old_question.choices = question.choices
                    old_question.title = question.title
                    puts "Updated question ##{old_question.id} in paragraph #{paragraph.id}"
                  end
                end
              end
              puts "Updated Paragraph paragraph #{paragraph.id} with #{paragraph.questions.count} questions"
            end
          end
        end
      else
        if parsing_paragraph
          content+="#{line}<br />"
        else
          puts "Unmatched: #{line}"
        end
      end
    end
  end
private
  #Input: solution file name, and verbose(boolean)
  #Output: array of solutions to each question
  def parse_solution(solfilename,verbose)
    solfile = File.open solfilename, "r"
    lines = IO.readlines solfile
    solution = {}
    puts "Solution: " if verbose
    lines.each do |line|
      if line=~/^(\d+)\.\s*(.*)$/
        solution[$1.to_i]=$2.strip.upcase
        puts "Question #{$1.to_i}: #{solution[$1.to_i]}" if verbose
      end
    end
    return solution
  end
end




