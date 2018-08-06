$(document).ready(function () {
    // show modal when new pathway button is pressed
    $("#pathway_modal_button").click(function () {
        $("#pathway_modal").modal();
    });

    $('#pathway_modal').on('shown.bs.modal', function () {
        focusOnFirstTextField('#pathway_modal');
    })

    $('#edit_pathway_modal').on('shown.bs.modal', function () {
        focusOnFirstTextField('#edit_pathway_modal');
    })

    $('#edit_step_modal').on('shown.bs.modal', function () {
        focusOnFirstTextField('#edit_step_modal');
    })

    function focusOnFirstTextField(modal_selector) {
        var first_text_field = $(modal_selector + " input:text").first();
        var value_length= first_text_field.val().length * 2;
        first_text_field.focus();
        first_text_field[0].setSelectionRange(value_length, value_length);
    }

    // show step one if modal is closed then opened again
    $('#pathway_modal').on('hidden.bs.modal', function () {
        $('#new_pathway_step1').show();
        $('#new_pathway_step2').hide();
        $('#pathway_steps_attributes_0_name').val('Preliminary Diagnosis'); // set default step name
        $("#pathway_modal input[name='step1']").clone().attr('type','submit')   // enter key presses 1st submit button
            .insertAfter("#pathway_modal input[name='step1']").prev().remove();
        $("#pathway_modal input[name='step2']").clone().attr('type','button')
            .insertAfter("#pathway_modal input[name='step2']").prev().remove();
        $('#pathway_form_errors').html(''); // clear errors
    })

    $('g.nodes').find('text tspan:first-child').attr('class', 'node-heading').attr('dy', '7');;
    $('g.nodes').find('text tspan:not(:first-child)').attr('dy', '10.4');
});