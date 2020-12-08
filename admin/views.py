import hashlib

from django.db import connection
from django.contrib import messages
from django.shortcuts import render, redirect
from django.views import View
from core.utils import create_auth_token
from cycloan.settings import TRIP_REQUESTED, TRIP_ONGOING, TRIP_REJECTED, TRIP_COMPLETED, TRIP_REVIEWED


class AdminLoginView(View):
    def get(self, request):
        print('hello')
        return redirect('login-view-for-admin')

    def post(self, request):
        admin_email = request.POST.get('admin-email')
        admin_pass = request.POST.get('admin-password')

        cursor = connection.cursor()
        sql = "SELECT ADMIN_PASSWORD, ADMIN_ID FROM ADMIN WHERE ADMIN_EMAIL=%s"
        cursor.execute(sql, [admin_email])
        result = cursor.fetchall()
        cursor.close()

        try:
            fetched_pass = result[0][0]
            hashed_admin_password = hashlib.sha256(admin_pass.encode()).hexdigest()
            if fetched_pass == hashed_admin_password:
                admin_id = result[0][1]
                request.session['admin_id'] = admin_id
                request.session['auth_token'] = create_auth_token(admin_id)
                request.session['user_type'] = 'admin'
                return redirect('admin-dashboard-view')

            else:
                messages.error(request, 'Password did not match. Enter correctly!')
                return redirect('admin-login-view')
        except:
            messages.error(request, 'Your email address is not found in our database. Enter it correctly!')
            return redirect('admin-login-view')


class AdminDashboardView(View):

    # @verify_auth_token
    # @check_customer
    def get(self, request):
        admin_id = request.session.get('admin_id')

        cursor = connection.cursor()
        sql = "SELECT ADMIN_NAME FROM ADMIN WHERE ADMIN_ID=%s"
        cursor.execute(sql, [admin_id])
        result = cursor.fetchall()
        cursor.close()

        admin_name = result[0][0]
        context = {'admin_name': admin_name}

        return render(request, 'admin_dashboard.html', context)


class ShowCycleListView(View):
    def get(self, request):
        cursor = connection.cursor()
        sql = "SELECT COUNT(*) FROM CYCLE"
        cursor.execute(sql)
        count = cursor.fetchall()
        cursor.close()
        c = int(count[0][0])
        if c == 0:
            messages.warning(request, 'No cycle to show')
            return redirect('admin-dashboard-view')
        else:
            cursor = connection.cursor()
            sql = "SELECT CYCLE_ID, MODEL, FARE_PER_DAY FROM CYCLE"
            cursor.execute(sql)
            cycle_list = cursor.fetchall()
            cursor.close()
            context = {'cycle_list': cycle_list}

            return render(request, 'cycle_list.html', context)


class ShowOwnerListView(View):
    def get(self, request):
        cursor = connection.cursor()
        sql = "SELECT COUNT(*) FROM OWNER"
        cursor.execute(sql)
        count = cursor.fetchall()
        cursor.close()
        c = int(count[0][0])
        if c == 0:
            messages.warning(request, 'No owner to show')
            return redirect('admin-dashboard-view')
        else:
            cursor = connection.cursor()
            sql = "SELECT OWNER_ID, OWNER_NAME, OWNER_PHONE, EMAIL_ADDRESS FROM OWNER "
            cursor.execute(sql)
            owner_list = cursor.fetchall()
            cursor.close()
            context = {'owner_list': owner_list}

            return render(request, 'owner_list.html', context)


class ShowCustomerListView(View):
    def get(self, request):
        cursor = connection.cursor()
        sql = "SELECT COUNT(*) FROM CUSTOMER"
        cursor.execute(sql)
        count = cursor.fetchall()
        cursor.close()
        c = int(count[0][0])
        if c == 0:
            messages.warning(request, 'No customer to show')
            return redirect('admin-dashboard-view')
        else:
            cursor = connection.cursor()
            sql = "SELECT CUSTOMER_ID, CUSTOMER_NAME, CUSTOMER_PHONE, EMAIL_ADDRESS FROM CUSTOMER "
            cursor.execute(sql)
            customer_list = cursor.fetchall()
            cursor.close()
            context = {'customer_list': customer_list}

            return render(request, 'customer_list.html', context)


class AdminRegisterView(View):
    def get(self, request):
        return render(request, 'admin_register.html')

    def post(self, request):
        fullname = request.POST.get('fullname')
        email = request.POST.get('email')
        password = request.POST.get('password')
        password_confirm = request.POST.get('password_confirm')

        if password != password_confirm:
            messages.warning(request, 'Passwords do not match. Check again')
            return redirect('admin-register-view')
        else:
            cursor = connection.cursor()
            sql = "SELECT COUNT(*) FROM ADMIN WHERE ADMIN_EMAIL=%s"
            cursor.execute(sql, [email])
            result = cursor.fetchall()
            cursor.close()
            count = int(result[0][0])
            if count == 0:
                hashed_password = hashlib.sha256(password.encode()).hexdigest()

                cursor = connection.cursor()
                sql = "INSERT INTO ADMIN(ADMIN_ID,ADMIN_NAME,ADMIN_EMAIL,ADMIN_PASSWORD) VALUES(ADMIN_INCREMENT.NEXTVAL, %s, %s, %s)"
                cursor.execute(sql, [fullname, email, hashed_password])
                connection.commit()
                cursor.close()

                messages.success(request, 'Successfully created account. Now you must verify your email and then you can log in.')
                return redirect('admin-dashboard-view')

            else:
                messages.warning(request, 'Account exists with similar email. Please provide different email')
                return redirect('admin-register-view')


class ShowTripListView(View):
    def get(self, request):
        cursor = connection.cursor()
        sql = "SELECT TRIP_ID, START_DATE_TIME, END_DATE_TIME, STATUS, FARE_CALCULATION(TRIP_ID)  FROM TRIP_DETAILS "
        cursor.execute(sql, [TRIP_REQUESTED])
        trip_list = cursor.fetchall()
        cursor.close()

        context = {
            'trip_list': trip_list,
        }

        return render(request, 'trip_list.html', context)
