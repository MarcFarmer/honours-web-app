jQuery(document).ready(function ($) {
    // keep sidebar on screen while scrolling
    var sidebar = $('.sidebar');
    var origOffsetY = sidebar.offset().top;

    function scroll() {
        if ($(window).scrollTop() >= origOffsetY) {
            var width = sidebar.parent().width();
            sidebar.addClass('sticky');
            sidebar.width(width);
        } else {
            sidebar.removeClass('sticky');
        }
    }

    document.onscroll = scroll;

    updateCurrentScore();

    // calculate and display score for current step in preview
    function updateCurrentScore() {
        var current_score = 0;
        $(".answer-button :input").each(function() {    // add each selected answer score to current score
            if ($(this).prop('checked')) {
                current_score += parseInt($(this).val());
            }
        });

        var current_score_element = $("span#current_score");    // show current score (sum of answer scores) to user
        current_score_element.text(current_score);

        selectNextStep(current_score);
    }

    $(function() {
        $(".answer-button").click(function() {
            if ($(this).hasClass('active')) {   // do nothing if this answer is already selected
                return false;
            }

            var clicked_answer_input = $(this).find('input');       // check radio button associated with this answer
            var new_score = parseInt( clicked_answer_input.val() );
            clicked_answer_input.attr('checked', true);

            $(this).siblings().each(function() {    // uncheck radio buttons for other answers to this question
                var answer_input = $(this).find('input');
                answer_input.attr('checked', false);
            });

            setTimeout(function() {     // calculate and display new score after selected answers have been updated
                updateCurrentScore();
            }, 0);
        });
    });

    // select next step in preview based on answers and highlight it for the user to see
    // OK button is disabled if there is no step can be reached with current answers
    function selectNextStep(current_score) {
        var found_next_step = false;
        var step_min_score = parseInt($('input[type="hidden"][name="step_min"]').val());
        var step_max_score = parseInt($('input[type="hidden"][name="step_max"]').val());

        $('.next-exit-step').each(function() {  // check all potential next steps
            var next_step_field = $(this).find('input[type="hidden"][name="next_step_id"]');
            var min_score = $(this).find('input[type="hidden"][name="min"]').val();
            var max_score = $(this).find('input[type="hidden"][name="max"]').val();

            var icon = $(this).find('.glyphicon');
            if (current_score >= min_score && current_score <= max_score) {     // highlight this as next step
                icon.addClass('glyphicon-ok');
                $(this).parent().addClass('alert').addClass('alert-success');
                next_step_field.removeProp('disabled');
                $('#preview_next_step').removeProp('disabled');     // enable OK button to go to the next step
                found_next_step = true;
                $('#next_step').text($(this).text());
            } else {        // remove highlight in case this next step was highlighted before
                icon.removeClass('glyphicon-ok');
                $(this).parent().removeClass('alert').removeClass('alert-success');
                next_step_field.prop('disabled', true);

                if (max_score < step_min_score || min_score > step_max_score) {
                    $(this).parent().addClass('alert').addClass('alert-warning');
                    $(this).children('.next-step-warning').text('Warning: This step cannot be reached');
                }
            }
        });

        if (!found_next_step) {
            $('#preview_next_step').prop('disabled', true);     // current score is not in range to go to any next step
            $('#next_step').text('No next step for current score (' + current_score + ')');
        }
    }

    $('.answer-button').click(function () {
        if (!$(this).hasClass('active')) {
            $(this).removeClass('btn-default');
            $(this).addClass('btn-success');

            $(this).siblings('label').each(function() {
                $(this).removeClass('btn-success');
                $(this).addClass('btn-default');
            });
        }
    });

    $('.preview-button').click(function () {
        if ($(this).hasClass('btn-default')) {
            $(this).removeClass('btn-default');
            $(this).addClass('btn-success');
        } else {
            $(this).removeClass('btn-success');
            $(this).addClass('btn-default');

        }
    });

    // tabs for editing questions and instructions / exit conditions
    $('#step_tabs').tab();

    // select question form by default
    $("#radio_question").prop('checked', true);
    $("#qi_form-1").show();

    // show Yes/No answers by default
    $("#radio_default_answers").prop('checked', true);
    showDefaultAnswers();
    hideCustomAnswers();

    // toggle between question and instruction forms
    $(function() {
        $("[name=toggle-qi-form]").click(function(){
          $('.toHide').hide();
          $("#qi_form-"+$(this).val()).show('slow');
        });
    });

    // toggle between question and instruction forms
    $(function() {
        $("[name=toggle-answer-fields]").click(function(){
            if ($(this).val() == 'default') {
                showDefaultAnswers();
                hideCustomAnswers();
            } else if ($(this).val() == 'custom') {
                showCustomAnswers();
                hideDefaultAnswers();
            }
        });
    });

    // toggle active step tab when the active tab is clicked
    $(function() {
        $("#step_tabs").on('click','.step-tab-enabled', function() {
            $(this).removeClass("step-tab-enabled");
            $(this).addClass("step-tab-disabled");

            $(this).siblings().each(function() {
                $(this).removeClass("step-tab-disabled");
                $(this).addClass("step-tab-enabled");
            });
        });
    });

    // show default Yes/No answers and enable them in form submission params
    function showDefaultAnswers() {
        $('#default_answers_fields').show();
        $('input.answer-content-yes').removeProp('disabled');
        $('input.answer-content-no').removeProp('disabled');
    }

    // hide default Yes/No answers and disable them, removing them form submission params
    function hideDefaultAnswers() {
        $('#default_answers_fields').hide();
        $('input.answer-content-yes').prop('disabled', true);
        $('input.answer-content-no').prop('disabled', true);
    }

    // show custom answers with previous user input still present and enable them in form submission params
    function showCustomAnswers() {
        $('#custom_answers_fields').show();
        $('#custom_answers_fields').find('input').each(function(){
            $(this).removeProp('disabled');
        });
    }

    // hide custom answers without removing user input and disable them, removing them form submission params
    function hideCustomAnswers() {
        $('#custom_answers_fields').hide();
        $('#custom_answers_fields').find('input').each(function(){
            $(this).prop('disabled', true);
        });
    }

    var exit_step_field = $(".autocomplete-text-field");
    exit_step_field.on('autocompleteresponse', function(event, ui) {
        var content = ui.content
        if (content != null) {
            if (content[0].id.length === 0) {
                $(this).autocomplete('close');
            }
        } else {
            $(this).autocomplete('close');
        }
    });
});