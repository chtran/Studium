class BadgeManager < ActiveRecord::Base
  attr_accessible :correct_qiar_counter, :cr_q_counter, :cr_qiar_counter, :math_q_counter, :math_qiar_counter, :perfect_replay_counter, :question_counter, :user_id, :wr_q_counter, :wr_qiar_counter

  def awardBadges(user,question,choice)
    user_entry=BadgeManager.find_or_create_by_user_id(user.id)

    # Increment/Reset counters
    if choice.correct?
      increment_q_counter(user_entry,question)
    else
      reset_qiar_counter(user_entry,question)
    end
    
    # Save
    user_entry.save!

    # Consider badges

  end

  def awardReplayBadge(user,question,counter)
    
  end

  def increment_q_counter(user_entry,question)
    user_entry.question_counter+=1
    user_entry.correct_qiar_counter+=1
    
    if question.question_type.cr?
      user_entry.cr_q_counter+=1
      user_entry.cr_qiar_counter+=1
    elsif question.question_type.wr?
      user_entry.wr_q_counter+=1
      user_entry.wr_qiar_counter+=1
    elsif question.question_type.math?
      user_entry.math_q_counter+=1
      user_entry.math_qiar_counter+=1
    end
  end

  def reset_qiar_counter(user_entry,question)
    user_entry.correct_qiar_counter=0
    
    if question.question_type.cr?
      user_entry.cr_qiar_counter=0
    elsif question.question_type.wr?
      user_entry.wr_qiar_counter=0
    elsif question.question_type.math?
      user_entry.math_qiar_counter=0
    end
  end

  def consider_badges(user_entry)

    if user_entry.correct_qiar_counter==10

    end

  end

  def consider_undefeated_badges(user_entry)
    
  end

  def consider_scholar_badges(user_entry)

  end

  def consider_reviewer_badges(user_entry)

  end

  def consider_mathematician_badges(user_entry)

  end

  def consider_pen_badges(user_entry)

  end

  def consider_reader_badges(user_entry)

  end

end
