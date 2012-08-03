class Sc < Thor
  desc "populate [FILENAME] [SOLFILENAME]","populate the database with SAT sentence completion questions."
  method_options force: :boolean
  method_options verbose: :boolean

  def populate(filename,solfilename)
    require File.expand_path("config/environment.rb")

    verbose=options[:verbose]
    solfile = File.open solfilename, "r"
    lines = IO.readlines solfile
    solution = {}
    puts "Solution: " if verbose
    lines.each do |line|
      if line=~/^(\d+)\.\s*(.*)$/
        solution[$1.to_i]=$2.upcase
        puts "Question #{$1.to_i}: #{solution[$1]}" if verbose
      end
    end
    file=File.open filename,"r"
    lines=IO.readlines filename
    question_type = QuestionType.where(type_name: "Sentence Completion").first
    question = nil
    num = nil
    prompt = nil
    choice = nil

    lines.each do |line|
      if line=~/^(\d+)\.?\s*(.*)$/
        question = question_type.questions.new
        num = $1.to_i
        puts "Creating Question #{num}" if verbose
        prompt = $2.strip.gsub(/-+/,"<bl />")
        puts "Prompt: #{prompt}" if verbose
        question.prompt = prompt
        question.title = prompt.split(" ")[0..5].join(" ")+(" ...")
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
              puts "Error for question with title: \"#{question.title}\". #{e.message}"
            end
          end
          question = nil
          num = nil
          choice = nil
          prompt = nil
        end
      end

    end
  rescue Errno::ENOENT => e
    puts "Data file not found."
  end

end
