import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/nine_primary_button.dart';
import '../../../../shared/widgets/buttons/nine_secondary_button.dart';
import '../blocs/booking_bloc.dart';
import '../blocs/booking_event.dart';
import '../blocs/booking_state.dart';
import '../widgets/booking_stepper_header.dart';
import '../widgets/contact_section_widget.dart';
import '../widgets/review_section_widget.dart';
import '../widgets/schedule_section_widget.dart';
import '../widgets/service_section_widget.dart';
import '../widgets/vehicle_section_widget.dart';

class BookingStepperScreen extends StatelessWidget {
  const BookingStepperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BookingBloc>()..add(InitBookingEvent()),
      child: const _BookingStepperView(),
    );
  }
}

class _BookingStepperView extends StatelessWidget {
  const _BookingStepperView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.danger,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        if (state.submissionStatus == BookingSubmissionStatus.success &&
            state.submittedBooking != null) {
          context.pushReplacement(
            RouteNames.bookingSuccess,
            extra: state.submittedBooking,
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<BookingBloc>();

        return Scaffold(
          backgroundColor: AppColors.canvas,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () {
                if (state.currentStep > 1) {
                  bloc.add(PrevStepEvent());
                } else {
                  context.pop();
                }
              },
            ),
            title: Text('Reservasi Servis Bengkel', style: AppTextStyles.h3),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    'Langkah ${state.currentStep}/5',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              BookingStepperHeader(
                currentStep: state.currentStep,
                onStepTapped: (step) {
                  // Only allow jumping backward or valid forward
                  if (step <= state.currentStep) {
                    bloc.add(GoToStepEvent(step));
                  }
                },
              ),
              Expanded(
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      )
                    : _buildCurrentStepView(context, state, bloc),
              ),
              _buildBottomActionBar(context, state, bloc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentStepView(BuildContext context, BookingState state, BookingBloc bloc) {
    switch (state.currentStep) {
      case 1:
        return ContactSectionWidget(
          initialName: state.customerName,
          initialPhone: state.customerPhone,
          initialEmail: state.customerEmail,
          initialAddress: state.address,
          initialNotes: state.notes,
          onUpdated: (name, phone, email, address, notes) {
            bloc.add(UpdateContactEvent(
              name: name,
              phone: phone,
              email: email,
              address: address,
              notes: notes,
            ));
          },
        );
      case 2:
        return VehicleSectionWidget(
          category: state.vehicleCategory,
          brand: state.vehicleBrand,
          model: state.vehicleModel,
          year: state.vehicleYear,
          licensePlate: state.licensePlate,
          transmission: state.transmissionType,
          onUpdated: ({
            required category,
            required brand,
            required model,
            required year,
            required licensePlate,
            required transmission,
          }) {
            bloc.add(UpdateVehicleEvent(
              category: category,
              brand: brand,
              model: model,
              year: year,
              licensePlate: licensePlate,
              transmission: transmission,
            ));
          },
        );
      case 3:
        return ServiceSectionWidget(
          availableServices: state.availableServices,
          selectedServices: state.selectedServices,
          onToggleService: (service) => bloc.add(ToggleServiceSelectionEvent(service)),
        );
      case 4:
        return ScheduleSectionWidget(
          workshops: state.workshops,
          selectedWorkshop: state.selectedWorkshop,
          selectedDate: state.selectedDate,
          timeSlots: state.timeSlots,
          selectedTimeSlot: state.selectedTimeSlot,
          onSelectWorkshop: (ws) => bloc.add(SelectWorkshopEvent(ws)),
          onSelectDate: (date) => bloc.add(SelectDateEvent(date)),
          onSelectTimeSlot: (slot) => bloc.add(SelectTimeSlotEvent(slot)),
        );
      case 5:
        return ReviewSectionWidget(
          state: state,
          onApplyVoucher: (code) => bloc.add(ApplyVoucherEvent(code)),
          onRemoveVoucher: () => bloc.add(RemoveVoucherEvent()),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomActionBar(BuildContext context, BookingState state, BookingBloc bloc) {
    final canProceed = state.canProceed(state.currentStep);
    final isLastStep = state.currentStep == 5;
    final isSubmitting = state.submissionStatus == BookingSubmissionStatus.submitting;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (state.currentStep > 1) ...[
              Expanded(
                flex: 1,
                child: NineSecondaryButton(
                  label: 'Kembali',
                  onPressed: isSubmitting ? null : () => bloc.add(PrevStepEvent()),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: NinePrimaryButton(
                label: isLastStep ? 'Konfirmasi Booking' : 'Lanjut',
                icon: isLastStep ? Icons.check_circle_outline_rounded : Icons.arrow_forward_rounded,
                isLoading: isSubmitting,
                onPressed: canProceed
                    ? () {
                        if (isLastStep) {
                          bloc.add(SubmitBookingEvent());
                        } else {
                          bloc.add(NextStepEvent());
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
