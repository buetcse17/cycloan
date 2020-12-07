from django.urls import path
from . import views

urlpatterns = [
    path('<int:cycle_id>',  views.CycleDetailsView.as_view(),    name='cycle-details-view'),
    path('add/',             views.CycleAddView.as_view(),       name='cycle-add-view'),
    path('delete/<int:cycle_id>',         views.CycleDeleteView.as_view(),     name='cycle-delete-view'),
    path('request/<int:cycle_id>',   views.RequestCycleView.as_view(),   name='request-cycle-view'),

    path('cancel/<int:trip_id>',       views.CancelCycleView.as_view(),     name='cancel-cycle-view'),
    path('approve/<int:trip_id>',   views.ApproveCycleView.as_view(),   name="approve-cycle-view"),
    path('receive/<int:trip_id>',   views.ReceiveCycleView.as_view(),       name='receive-cycle-view'),
]